let keybindings = [
    {
        name: fuzzy_history
        modifier: control
        keycode: char_r
        mode: [emacs, vi_normal, vi_insert]
        event: [
            {
                send: ExecuteHostCommand
                cmd: "do {
                    $env.SHELL = /usr/bin/bash
                    commandline edit --insert (
                      history
                      | get command
                      | reverse
                      | uniq
                      | str join (char -i 0)
                      | fzf --scheme=history 
                          --read0
                          --layout=reverse
                          --height=40%
                          --bind 'ctrl-/:change-preview-window(right,70%|right)'
                          --preview='echo -n {} | nu --stdin -c \'nu-highlight\''
                      | decode utf-8
                      | str trim
                    )
                }"
            }
        ]
    }
]

register-keybindings $keybindings
