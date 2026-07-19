# ── Keep the Mac awake while Claude Code runs ────────────────────────────────

if $nu.os-info.name == "macos" {
    def --wrapped claude [...args] {
        ^caffeinate -di ^claude ...$args
    }
}
