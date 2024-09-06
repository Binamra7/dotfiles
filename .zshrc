if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(git)

source $ZSH/oh-my-zsh.sh

source ~/.zsh_profile

# aliases
alias nv=nvim
#alias nv="kitty --config ~/.config/kitty/nvim.conf nvim"
alias cd..="cd .."
alias bat=batcat
alias copy='xclip -selection clipboard <'
alias reload!='. ~/.zshrc'
alias sudo='sudo '

alias ls='lsd'
alias ll='lsd -l'
alias la='lsd -la'
alias lh='lsd -lh'
alias lla='lsd -lha'
alias lr='lsd -R'
alias lra='lsd -laR'
alias lss='lsd -l --size'
alias lt='lsd -lt'
alias ltree='lsd --tree'
alias ltreea='lsd --tree -a'


source ~/powerlevel10k/powerlevel10k.zsh-theme
source ~/powerlevel10k/powerlevel10k.zsh-theme
source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

eval "$(zoxide init zsh)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

