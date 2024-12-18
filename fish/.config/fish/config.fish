if status is-interactive
    if not set -q TMUX
        exec tmux
    end
    abbr -a dc 'docker-compose'
    abbr -a dcu 'docker-compose up -d'
    abbr -a dcd 'docker-compose down'
    abbr -a d 'docker'
end
