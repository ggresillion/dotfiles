if status is-interactive
    if not set -q TMUX
        exec tmux
    end
    abbr -a dc 'docker-compose'
    abbr -a dcu 'docker-compose up -d'
    abbr -a dcd 'docker-compose down'
    abbr -a d 'docker'

    set -x EDITOR nvim
end

# pnpm
set -gx PNPM_HOME "/Users/guillaume/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
