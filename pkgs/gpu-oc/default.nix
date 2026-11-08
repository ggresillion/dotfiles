{
  writeShellApplication,
  coreutils,
  gnugrep,
  jq,
  socat,
  procps,
  systemd,
  libnotify,
  furmark,
  memtest_vulkan,
  vkmark,
}:

# Automatic RX 9070 XT overclock search through the LACT daemon socket.
# Settings are applied live and never saved (/etc/lact is read-only), so a
# crash or reboot falls back to the declarative config in hosts/desktop/gaming.nix.
#
# gpu-oc tune     run or resume the search (needs the graphical session)
# gpu-oc status   progress and best settings so far
# gpu-oc reset    re-apply the starting config and forget the search
writeShellApplication {
  name = "gpu-oc";
  # jq filters take their variables through --arg, in single quotes.
  excludeShellChecks = [ "SC2016" ];
  runtimeInputs = [
    coreutils
    gnugrep
    jq
    socat
    procps
    systemd
    libnotify
    furmark
    memtest_vulkan
    vkmark
  ];
  text = ''
    id="''${GPU_OC_ID:-1002:7550-1458:2424-0000:03:00.0}"
    dir="''${XDG_STATE_HOME:-$HOME/.local/state}/gpu-oc"
    state="$dir/state.json"
    log_file="$dir/log"
    # Test durations (seconds).
    fm_secs="''${GPU_OC_FURMARK:-60}"
    mt_secs="''${GPU_OC_MEMTEST:-60}"
    soak_secs="''${GPU_OC_SOAK:-300}"
    # Search bounds (driver limits: voltage -200..0 mV, memory <= 1500 MHz).
    v_min=-200
    m_max=1500
    c_max=200
    mkdir -p "$dir"
    hwmon=$(echo /sys/bus/pci/devices/0000:03:00.0/hwmon/hwmon*)

    log() { printf '%s %s\n' "$(date '+%F %T')" "$*" | tee -a "$log_file" >&2; }
    st() { jq -r "$1" "$state"; }
    st_set() {
      local f=$1
      shift
      jq "$@" "$f" "$state" >"$state.tmp" && mv "$state.tmp" "$state" && sync "$state"
    }
    lact() { socat -t30 - UNIX-CONNECT:/run/lactd.sock <<<"$1"; }

    # apply VOLTAGE_OFFSET MAX_MEMORY_CLOCK CLOCK_OFFSET
    apply() {
      local cfg
      cfg=$(jq -c --argjson v "$1" --argjson m "$2" --argjson c "$3" \
        '.base + {voltage_offset: $v, max_memory_clock: $m}
          + (if $c == 0 then {} else {gpu_clock_offsets: {"0": $c}} end)' "$state")
      # LACT refuses changes while it reloads the GPU after a reset.
      for _ in $(seq 12); do
        lact "{\"command\":\"set_gpu_config\",\"args\":{\"id\":\"$id\",\"config\":$cfg}}" | grep -q '"ok"' &&
          lact '{"command":"confirm_pending_config","args":{"command":"confirm"}}' | grep -q '"ok"' &&
          return 0
        sleep 5
      done
      return 1
    }

    # Kill the stress tests if the GPU overheats (that's not instability:
    # the whole search is aborted).
    watchdog() {
      while sleep 2; do
        local j m
        j=$(cat "$hwmon/temp2_input")
        m=$(cat "$hwmon/temp3_input")
        if ((j > 105000 || m > 100000)); then
          echo "junction $((j / 1000))C mem $((m / 1000))C" >"$dir/overheat"
          pkill -x furmark || true
          pkill -x vkmark || true
          pkill -x memtest_vulkan || true
        fi
      done
    }

    # Each test sets REASON on failure, and SCORE / BW on success.
    furmark_test() {
      local out="$dir/furmark.out"
      rm -f /tmp/furmark-furmark.log
      if ! timeout -k 10 $(($1 + 60)) furmark --demo furmark-knot-vk --gpu-index 0 \
        --width 1920 --height 1080 --max-time "$1" --benchmark --no-score-box \
        --artifact-scanner >"$out" 2>&1; then
        REASON="furmark crashed"
        return 1
      fi
      SCORE=$(grep -aoP 'SCORE\s*:\s*\K[0-9]+' "$out" || true)
      # Score per minute of run, comparable across test lengths.
      [[ -n "$SCORE" ]] && SCORE=$((SCORE * 60 / $1))
      [[ -n "$SCORE" ]] || { REASON="furmark gave no score"; return 1; }
      if grep -a '\[ArtifactScanner\]' /tmp/furmark-furmark.log 2>/dev/null | grep -viq 'scanner for GPU'; then
        REASON="furmark artifacts"
        return 1
      fi
    }

    # Light, high-clock and fast-changing loads (where undervolts usually break).
    vkmark_test() {
      local args=() s
      for s in vertex texture shading effect2d desktop cube clear; do
        args+=(-b "$s:duration=$1")
      done
      if ! timeout -k 10 $(($1 * 7 + 60)) vkmark -s 1280x720 "''${args[@]}" >"$dir/vkmark.out" 2>&1 ||
        ! grep -q 'vkmark Score' "$dir/vkmark.out"; then
        REASON="vkmark crashed"
        return 1
      fi
    }

    memtest_test() {
      local out="$dir/memtest.out"
      (cd "$dir" && timeout -s INT -k 15 "$1" memtest_vulkan) >"$out" 2>&1 || true
      grep -aq 'testing PASSed' "$out" || { REASON="VRAM errors"; return 1; }
      BW=$(grep -aoP 'checked:\s+[0-9.]+GB\s+\K[0-9.]+' "$out" | tail -1)
    }

    # try KIND V M C: apply and stress one candidate, recording the result.
    # The candidate is saved as pending first: if the session or machine
    # dies during the test, the next run counts it as a failure.
    try() {
      local kind=$1 v=$2 m=$3 c=$4 t0 ok=true wd
      st_set '.pending = {kind: $k, v: $v, m: $m, c: $c}' --arg k "$kind" \
        --argjson v "$v" --argjson m "$m" --argjson c "$c"
      log "[$kind] testing voltage $v mV, memory $m MHz, clock offset +$c MHz"
      SCORE=0 BW="" REASON=""
      rm -f "$dir/overheat"
      apply "$v" "$m" "$c" || { log "LACT refused the config"; exit 1; }
      t0=$(date +%s)
      watchdog &
      wd=$!
      case $kind in
        memory) memtest_test "$mt_secs" && furmark_test 30 ;;
        soak) furmark_test "$soak_secs" && memtest_test 120 && vkmark_test 15 ;;
        *) furmark_test "$fm_secs" && vkmark_test 5 ;;
      esac || ok=false
      kill "$wd" 2>/dev/null || true
      if [[ -e "$dir/overheat" ]]; then
        log "ABORT: overheating ($(cat "$dir/overheat")), restoring the starting config"
        apply "$(st .best0.v)" "$(st .best0.m)" 0
        st_set '.pending = null'
        notify-send -u critical "gpu-oc" "Aborted: GPU overheating"
        exit 1
      fi
      if journalctl -k --since "@$t0" --no-pager -o cat |
        grep -Eiq 'amdgpu.*(timeout|reset|fault|hang)|gpu reset|ring .*timed? ?out'; then
        ok=false REASON="amdgpu error in kernel log"
      elif ! $ok && (($(date +%s) - t0 < 15)); then
        # A test that can't even start means the display is gone (the
        # compositor restarted after an earlier GPU reset): not a result.
        log "  test could not start ($REASON): stopping, run again from the new session"
        st_set '.pending = null'
        exit 1
      fi
      # A real undervolt raises the power-limited score; a big drop means
      # clock stretching or memory error correction.
      if $ok && [[ "$kind" != soak ]] && (($(st '.ref // 0') > 0)) &&
        ((SCORE * 100 < $(st .ref) * 97)); then
        ok=false REASON="score dropped ($SCORE vs $(st .ref))"
      fi
      st_set '.pending = null | .results += [{kind: $k, v: $v, m: $m, c: $c, ok: $ok,
          score: $s, bw: $b, reason: $r, at: now | todate}]' \
        --arg k "$kind" --argjson v "$v" --argjson m "$m" --argjson c "$c" \
        --argjson ok "$ok" --argjson s "$SCORE" --argjson b "''${BW:-0}" --arg r "$REASON"
      if $ok; then
        log "  PASS score $SCORE''${BW:+ bandwidth $BW GB/s}"
      else
        log "  FAIL: $REASON"
        sleep 10 # let the driver settle after a failure
      fi
      $ok
    }

    # Lowest failed value of a kind (or empty).
    failed() { jq -r --arg k "$1" --arg f "$2" "[.results[] | select(.kind == \$k and (.ok | not)) | .[\$f]] | $3 // empty" "$state"; }

    tune() {
      if [[ ! -e "$state" ]]; then
        local base
        base=$(lact "{\"command\":\"get_gpu_config\",\"args\":{\"id\":\"$id\"}}" | jq -c .data)
        jq -n --argjson b "$base" '{base: $b, phase: "baseline", pending: null, results: [],
          best0: {v: ($b.voltage_offset // 0), m: ($b.max_memory_clock // 1259), c: 0}}
          | .best = .best0' >"$state"
        log "new search, starting from $(jq -c .best "$state")"
      fi
      if [[ "$(st .pending)" != null ]]; then
        log "previous test of $(st -c .pending 2>/dev/null || st .pending) never finished: counted as a crash"
        st_set '.results += [.pending + {ok: false, reason: "crash", at: now | todate}] | .pending = null'
      fi

      local v m c phase next
      while :; do
        v=$(st .best.v) m=$(st .best.m) c=$(st .best.c) phase=$(st .phase)
        case $phase in
          baseline)
            if [[ "$(st '[.results[] | select(.kind == "baseline")] | length')" != 0 ]]; then
              log "the starting config failed: check the test harness"
              exit 1
            fi
            try baseline "$v" "$m" "$c" || { log "the starting config failed"; exit 1; }
            st_set '.ref = $s | .phase = "voltage"' --argjson s "$SCORE"
            ;;
          voltage)
            # Steps of -20 mV until a failure, then one -10 mV refinement.
            local f
            f=$(failed voltage v max)
            if [[ -z "$f" ]]; then next=$((v - 20 < v_min ? v_min : v - 20)); else next=$((v - 10)); fi
            if ((next == v)) || { [[ -n "$f" ]] && ((next <= f)); }; then
              # 10 mV safety margin over the lowest passing value (games
              # vary more than a few minutes of stress tests).
              if ((v < $(st .best0.v))); then v=$((v + 10)); fi
              log "voltage done: $v mV"
              st_set '.best.v = $v | .phase = "memory"' --argjson v "$v"
            elif try voltage "$next" "$m" "$c"; then
              st_set '.best.v = $v | .ref = ([.ref, $s] | max)' --argjson v "$next" --argjson s "$SCORE"
            fi
            ;;
          memory)
            # GDDR6 retries errors instead of crashing: keep the clock with
            # the best measured bandwidth, not the highest passing one.
            if [[ -z "$(failed memory m min)" ]] && ((m < m_max)) &&
              ! jq -e '[.results[] | select(.kind == "memory" and .ok)] | length > 1
                and (.[-1].bw < .[-2].bw)' "$state" >/dev/null; then
              if [[ "$(st '[.results[] | select(.kind == "memory")] | length')" == 0 ]]; then
                try memory "$v" "$m" "$c" || { log "memory baseline failed"; exit 1; }
              else
                try memory "$v" "$((m + 25))" "$c" && st_set '.best.m += 25'
              fi
            else
              next=$(jq '[.results[] | select(.kind == "memory" and .ok)] | max_by(.bw) | .m' "$state")
              # One step back from the edge when the next clock failed.
              if [[ -n "$(failed memory m min)" ]] && ((next + 25 >= $(failed memory m min))) &&
                ((next > $(st .best0.m))); then next=$((next - 25)); fi
              log "memory done: $next MHz"
              st_set '.best.m = $m | .phase = "clock"' --argjson m "$next"
            fi
            ;;
          clock)
            if [[ -z "$(failed clock c min)" ]] && ((c < c_max)); then
              try clock "$v" "$m" "$((c + 50))" && st_set '.best.c += 50'
            else
              # One step of margin under the highest passing offset.
              ((c > 0)) && c=$((c - 50))
              log "clock offset done: +$c MHz"
              st_set '.best.c = $c | .phase = "soak"' --argjson c "$c"
            fi
            ;;
          soak)
            if try soak "$v" "$m" "$c"; then
              st_set '.phase = "done"'
            elif ((c > 0)); then
              st_set '.best.c = 0'
            elif ((v < $(st .best0.v))); then
              st_set '.best.v += 10'
            elif ((m > $(st .best0.m))); then
              st_set '.best.m -= 25'
            else
              log "the starting config failed the soak test"
              exit 1
            fi
            ;;
          done)
            apply "$v" "$m" "$c"
            log "DONE: voltage $v mV, memory $m MHz, clock offset +$c MHz (applied until reboot)"
            notify-send "gpu-oc" "Done: $v mV, $m MHz memory, +$c MHz clock" || true
            return 0
            ;;
        esac
      done
    }

    case "''${1:-status}" in
      tune) tune ;;
      status)
        tail -n 30 "$log_file" 2>/dev/null || true
        [[ -e "$state" ]] && jq -c '{phase, best, ref}' "$state"
        ;;
      reset)
        [[ -e "$state" ]] && apply "$(st .best0.v)" "$(st .best0.m)" 0
        rm -f "$state"
        log "search reset"
        ;;
      *)
        echo "usage: gpu-oc tune|status|reset" >&2
        exit 1
        ;;
    esac
  '';
}
