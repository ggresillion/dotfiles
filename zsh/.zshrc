export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="robbyrussell"

# Plugins
plugins=(
    git
    docker
    docker-compose
    zsh-autocomplete
    zsh-syntax-highlighting
    zsh-autosuggestions
    direnv
)

# Autocompletion
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src

source $ZSH/oh-my-zsh.sh

# Zoxide
eval "$(zoxide init zsh)"

# Aliases
alias vim="nvim"
alias d="docker"
alias cd="z"
alias dc="docker compose"

# Environment variables
export XDG_CONFIG_HOME="$HOME/.config"
export EDITOR='nvim'
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export PATH=$PATH:$HOME/go/bin
export PATH=$PATH:$HOME/scripts

# Tmux
if [ -z "$TMUX" ]
then
    tmux attach -t TMUX || tmux new -s TMUX
fi

