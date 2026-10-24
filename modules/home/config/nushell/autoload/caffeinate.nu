# ── Keep the Mac awake while Claude Code runs ────────────────────────────────
# defs must be top-level: inside an `if` block they are scoped to that block.

def --wrapped claude [...args] {
    if $nu.os-info.name == "macos" {
        ^caffeinate -di ^claude ...$args
    } else {
        ^claude ...$args
    }
}

# Keep the Mac awake indefinitely until `awake stop` is run.
# Detached via sh so it outlives this shell (nushell jobs die with it).
def awake [action?: string] {
    if $nu.os-info.name != "macos" { return }
    if $action == "stop" {
        ^pkill -f "caffeinate -dis" | ignore
    } else {
        ^sh -c "caffeinate -dis >/dev/null 2>&1 &"
    }
}
