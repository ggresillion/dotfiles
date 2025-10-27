$env.config.keybindings ++= [
    {
        name: fuzzy_history
        modifier: none
        keycode: char_/
        mode: [vi_normal]
        event: [
            {
                send: ExecuteHostCommand
                cmd: "do {
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
                      | decode utf-8
                      | str trim
                    )
                }"
            }
        ]
    }
]

