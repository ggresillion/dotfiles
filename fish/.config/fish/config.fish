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
set -x OPENROUTER_API_KEY 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
starship init fish | source
