export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(
    git
    docker
    docker-compose
    zsh-autocomplete
    zsh-syntax-highlighting
    zsh-autosuggestions
)

# autocompletion
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src

source $ZSH/oh-my-zsh.sh

export EDITOR='nvim'

alias vim="nvim"
alias d="docker"
alias cd="z"
alias dc="docker compose"

export PATH=$PATH:$HOME/go/bin

eval "$(zoxide init zsh)"
eval "$(direnv hook zsh)"

if [ -z "$TMUX" ]
then
    tmux attach -t TMUX || tmux new -s TMUX
fi

