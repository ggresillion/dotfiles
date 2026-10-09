{
  writeShellApplication,
  openrgb-git,
  coreutils,
  gnugrep,
  gawk,
}:

# Applies one color to every device of the running OpenRGB SDK server.
#
# Always goes through the server (never the CLI's local detection): a second
# local detection racing the server on the same SMBus/HID devices is what made
# colors inconsistent. It also waits for the server to finish detecting, since
# a client connecting mid-detection only sees the devices found so far (e.g.
# DRAM/GPU but not the USB controllers).
writeShellApplication {
  name = "rgb-sync";
  runtimeInputs = [
    openrgb-git
    coreutils
    gnugrep
    gawk
  ];
  text = ''
    hex="''${1:?usage: rgb-sync <hex>}"
    hex="''${hex#\#}"
    if ! [[ "$hex" =~ ^[0-9A-Fa-f]{6}$ ]]; then
      echo "rgb-sync: invalid color '$hex'" >&2
      exit 1
    fi
    port="''${RGB_SYNC_PORT:-6742}"
    timeout_s="''${RGB_SYNC_TIMEOUT:-90}"

    # Wait for the server port, so openrgb's autoconnect never falls back to
    # local detection.
    deadline=$((SECONDS + timeout_s))
    until (exec 3<>"/dev/tcp/127.0.0.1/$port") 2>/dev/null; do
      if ((SECONDS >= deadline)); then
        echo "rgb-sync: OpenRGB server not reachable on port $port" >&2
        exit 1
      fi
      sleep 1
    done

    # Autoconnect (not --client: in this build it only fetches part of the
    # controller list). Wait until the device list stops growing.
    list_devices() { openrgb --list-devices 2>/dev/null || true; }
    prev=-1 stable=0
    while :; do
      devices="$(list_devices)"
      count="$(grep -cE '^[0-9]+: ' <<<"$devices" || true)"
      if ((count > 0 && count == prev)); then
        stable=$((stable + 1))
        ((stable >= 2)) && break
      else
        stable=0
      fi
      prev=$count
      if ((SECONDS >= deadline)); then
        ((count > 0)) && break
        echo "rgb-sync: no devices reported by the OpenRGB server" >&2
        exit 1
      fi
      sleep 2
    done

    # One pass, one mode per device: Static when supported (kept by the
    # hardware itself), Direct otherwise.
    mapfile -t args < <(awk -v c="$hex" '
      /^[0-9]+: / { if (id != "") emit(); id = $1; sub(":", "", id); mode = "direct"; next }
      /^ *Modes:/ { if ($0 ~ /[[ ]Static[] ]|[[ ]Static$/) mode = "static" }
      function emit() { print "--device"; print id; print "--mode"; print mode; print "--color"; print c }
      END { if (id != "") emit() }
    ' <<<"$devices")

    echo "rgb-sync: applying #$hex to $count device(s)"
    openrgb "''${args[@]}"
  '';
}
