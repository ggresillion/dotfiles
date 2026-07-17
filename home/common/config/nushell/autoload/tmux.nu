# ── Window auto-rename when inside tmux (port of zellij tab-rename logic) ────

def tmux_state_dir [] { $"($env.HOME)/.local/state/tmux/windows" }
def tmux_last_auto_file [] { $"(tmux_state_dir)/($nu.pid).last_auto" }
def tmux_pinned_file [] { $"(tmux_state_dir)/($nu.pid).pinned" }

def tmux_is_pinned [] { (tmux_pinned_file) | path exists }

def tmux_set_pinned [] {
    mkdir (tmux_state_dir)
    "" | save -f (tmux_pinned_file)
}

def tmux_get_last_auto [] {
    let f = (tmux_last_auto_file)
    if ($f | path exists) { try { open $f | str trim } catch { null } } else { null }
}

def tmux_set_last_auto [name: string] {
    mkdir (tmux_state_dir)
    $name | save -f (tmux_last_auto_file)
}

def tmux_current_window_name [] {
    let r = (do -i { ^tmux display-message -p '#W' } | complete)
    if $r.exit_code != 0 { return null }
    $r.stdout | str trim
}

def tmux_was_manually_renamed [] {
    let last_auto = (tmux_get_last_auto)
    if $last_auto == null { return false }
    let current = (tmux_current_window_name)
    if $current == null { return false }
    $current != $last_auto
}

def tmux_compute_window_name [] {
    let current_dir = pwd
    mut name = if ($current_dir == $env.HOME) {
        "~"
    } else {
        ($current_dir | path parse | get stem)
    }

    let in_git = (do -i { git rev-parse --is-inside-work-tree } | complete | get stdout | str trim)
    if ($in_git == "true") {
        let git_root_super = (do -i { git rev-parse --show-superproject-working-tree } | complete | get stdout | str trim)
        let git_root = if ($git_root_super == "") {
            (do -i { git rev-parse --show-toplevel } | complete | get stdout | str trim)
        } else {
            $git_root_super
        }
        if (($git_root | str lowercase) != ($current_dir | str lowercase)) {
            let repo_name = ($git_root | path parse | get stem)
            let subpath = ($current_dir | str replace $git_root "")
            $name = $"($repo_name):($subpath)"
        }
    }

    $name
}

def tmux_update_window_name_prompt [] {
    if ("TMUX" not-in $env) { return }
    if (tmux_is_pinned) { return }
    if (tmux_was_manually_renamed) { tmux_set_pinned; return }
    let name = (tmux_compute_window_name)
    ^tmux rename-window $name
    tmux_set_last_auto $name
}

def tmux_update_window_name_execution [] {
    if ("TMUX" not-in $env) { return }
    if (tmux_is_pinned) { return }
    if (tmux_was_manually_renamed) { tmux_set_pinned; return }
    let cmd_name = (commandline | str trim | split row ' ' | first)
    ^tmux rename-window $cmd_name
    tmux_set_last_auto $cmd_name
}

# Manually rename current window and pin it
def "window rename" [name: string] {
    if ("TMUX" not-in $env) { print "Not in tmux"; return }
    ^tmux rename-window $name
    tmux_set_pinned
    tmux_set_last_auto $name
}

# Re-enable auto-rename for current window
def "window unpin" [] {
    rm -f (tmux_pinned_file)
    rm -f (tmux_last_auto_file)
}

$env.config.hooks.pre_prompt = (
    $env.config.hooks.pre_prompt ++
    [{ tmux_update_window_name_prompt }]
)

$env.config.hooks.pre_execution = (
    $env.config.hooks.pre_execution ++
    [{ tmux_update_window_name_execution }]
)
