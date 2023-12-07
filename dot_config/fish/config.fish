if status is-interactive
    # Commands to run in interactive sessions can go here
    set -g fish_greeting

    set -x EDITOR /usr/bin/nvim

    fish_add_path $HOME/go/bin

    alias vim "nvim"
    alias vi "nvim"
    alias v "nvim"

    alias d "docker"
    alias dc "docker compose"
end
