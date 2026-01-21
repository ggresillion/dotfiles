def zellij_update_tabname_prompt [] {
    if ("ZELLIJ" in $env) {
        let current_dir = pwd;
        
        mut tab_name = if ($current_dir == $env.HOME) {
            "~"
        } else {
            ($current_dir | path parse | get stem)
        };
        
        let in_git = (do -i { git rev-parse --is-inside-work-tree } | complete | get stdout | str trim);
        if ($in_git == "true") {
            let git_root_super = (do -i { git rev-parse --show-superproject-working-tree } | complete | get stdout | str trim);
            let git_root = if ($git_root_super == "") {
                (do -i { git rev-parse --show-toplevel } | complete | get stdout | str trim)
            } else {
                $git_root_super
            };
            if (($git_root | str downcase) != ($current_dir | str downcase)) {
                let repo_name = ($git_root | path parse | get stem);
                let subpath = $current_dir | str replace $git_root "";
                $tab_name = $"($repo_name):($subpath)"
            }
        }
        
        zellij action rename-tab $tab_name;
    }
}

def zellij_update_tabname_execution [] {
    if ("ZELLIJ" in $env) {
        let cmd = (commandline | str trim);
        let cmd_name = ($cmd | split row ' ' | first);
        zellij action rename-tab $cmd_name;
    }
}

$env.config.hooks.pre_prompt = (
  $env.config.hooks.pre_prompt ++ 
  [
    {
        zellij_update_tabname_prompt
    }
  ]
)

$env.config.hooks.pre_execution = (
  $env.config.hooks.pre_execution ++
  [
    {
        zellij_update_tabname_execution
    }
  ]
)
