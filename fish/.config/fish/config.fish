if status is-interactive
    abbr -a dc 'docker-compose'
    abbr -a dcu 'docker-compose up -d'
    abbr -a dcd 'docker-compose down'
    abbr -a d 'docker'

    set -x EDITOR nvim

    pyenv init - fish | source
    starship init fish | source

    function fish_greeting; end
end
