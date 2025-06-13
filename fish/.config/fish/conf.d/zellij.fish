# Launch zellij automatically in interactive sessions (if not already running inside it)
if status is-interactive
    if not set -q ZELLIJ
        zellij
    end
end

# Function to rename Zellij tab to current directory
function zellij_tab_name_update --on-variable PWD
    if set -q ZELLIJ
        set current_dir (basename $PWD)
        if test $PWD = $HOME
            set current_dir "~"
        end
        nohup zellij action rename-tab $current_dir >/dev/null 2>&1 &
    end
end

zellij_tab_name_update
