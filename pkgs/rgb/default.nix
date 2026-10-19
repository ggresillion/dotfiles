{
  writeShellApplication,
  openrgb-git,
  coreutils,
  gawk,
  util-linux,
}:

# rgb                       print the mode
# rgb off|white|auto|next   set a mode (auto = noctalia wallpaper color)
# rgb apply [--wait]        re-apply the mode (--wait: server may still be detecting)
# rgb palette <hex>         new wallpaper color, applied in auto mode
writeShellApplication {
  name = "rgb";
  runtimeInputs = [
    openrgb-git
    coreutils
    gawk
    util-linux
  ];
  text = ''
    state="''${XDG_STATE_HOME:-$HOME/.local/state}"
    mode_file="$state/rgb-mode"
    color_file="$state/rgb-color"

    mode() {
      case "$(cat "$mode_file" 2>/dev/null)" in
        off) echo off ;;
        white) echo white ;;
        *) echo auto ;;
      esac
    }

    color() {
      case "$1" in
        off) echo 000000 ;;
        white) echo ffffff ;;
        auto) tr -d '[:space:]#' <"$color_file" 2>/dev/null || echo 8caaee ;;
      esac
    }

    # Device list from the OpenRGB server (never let the CLI fall back to its
    # own detection). With --wait, poll until the list stops growing.
    devices() {
      local wait=$1 prev="" cur=""
      for _ in $(seq $((wait ? 45 : 5))); do
        if (exec 3<>/dev/tcp/127.0.0.1/6742) 2>/dev/null; then
          cur="$(openrgb --list-devices 2>/dev/null || true)"
          [[ -n "$cur" ]] && { ((!wait)) || [[ "$cur" == "$prev" ]]; } && break
          prev="$cur"
        fi
        sleep $((wait ? 2 : 1))
      done
      echo "$cur"
    }

    set_color() {
      local wait=0 hex run="''${XDG_RUNTIME_DIR:-/tmp}" me
      [[ "$1" == --wait ]] && wait=1 && shift
      hex="$1"

      # Key spam: only the latest request applies, older waiting ones drop.
      me="$(date +%s%N)"
      echo "$me" >"$run/rgb.req"
      exec 9>"$run/rgb.lock"
      flock 9
      [[ "$(cat "$run/rgb.req")" == "$me" ]] || exit 0

      # Static mode when the device has one ('Solid Color' on QMK), else Direct.
      mapfile -t args < <(devices "$wait" | awk -v c="$hex" '
        function out() { if (id != "") printf "--device\n%s\n--mode\n%s\n--color\n%s\n", id, m, c }
        /^[0-9]+: / { out(); id = $1 + 0; m = "direct" }
        /^ *Modes:/ && /[[ ]Static([] ]|$)/ { m = "static" }
        /^ *Modes:/ && /Solid Color/ { m = "Solid Color" }
        END { out() }
      ')
      ((''${#args[@]})) || { echo "rgb: no OpenRGB devices" >&2; exit 1; }

      # The CLI sends at once but lingers ~1s: background it, without the lock.
      openrgb "''${args[@]}" >/dev/null 9>&- &
      # Keychron QMK reloads its saved color on the frame after an effect
      # change (its RGB key steps the effect), so send to it again.
      sleep 0.15
      for ((i = 0; i < ''${#args[@]}; i += 6)); do
        [[ "''${args[i + 3]}" == "Solid Color" ]] && openrgb "''${args[@]:i:6}" >/dev/null 9>&- &
      done
      # systemd would kill the CLI before it sends: wait there.
      if ((wait)); then wait; fi
    }

    set_mode() {
      mkdir -p "$state"
      echo "$1" >"$mode_file"
      set_color "$(color "$1")"
    }

    case "''${1:-}" in
      "") mode ;;
      off | white | auto) set_mode "$1" ;;
      next)
        case "$(mode)" in
          off) set_mode white ;;
          white) set_mode auto ;;
          *) set_mode off ;;
        esac
        ;;
      apply) set_color ''${2:+"$2"} "$(color "$(mode)")" ;;
      palette) [[ "$(mode)" != auto ]] || set_color "''${2:?hex}" ;;
      *)
        echo "usage: rgb [off|white|auto|next|apply [--wait]|palette <hex>]" >&2
        exit 1
        ;;
    esac
  '';
}
