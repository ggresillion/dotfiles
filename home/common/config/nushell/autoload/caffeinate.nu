# ── Keep the Mac awake while Claude Code runs ────────────────────────────────

if $nu.os-info.name == "macos" {
    def --wrapped claude [...args] {
        ^caffeinate -di ^claude ...$args
    }

    # Keep the Mac awake indefinitely until `awake stop` is run.
    def awake [action?: string] {
        if $action == "stop" {
            ^pkill -f "caffeinate -dis" | ignore
        } else {
            ^caffeinate -dis &
        }
    }
}
