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
alias python=python3

# firefox
alias ff='/opt/firefox/firefox'
alias firefox=ff
alias ffs='ff --search'

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

alias ff='/opt/firefox/firefox'

alias lock='i3lock -c 000000'

alias xc='xclip -selection clipboard'

# Brightness control
alias bu='sudo brightnessctl set 50000'
alias bd='sudo brightnessctl set 5000'

source ~/powerlevel10k/powerlevel10k.zsh-theme
source ~/powerlevel10k/powerlevel10k.zsh-theme
source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

eval "$(zoxide init zsh)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion


# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"


# Start the SSH agent and add the GitLab key
eval "$(ssh-agent -s)" >/dev/null 2>&1
ssh-add ~/.ssh/gitlab-bajra >/dev/null 2>&1
ssh-add ~/.ssh/gitlab-local>/dev/null 2>&1
ssh-add ~/.ssh/id_ed25519>/dev/null 2>&1

# Set the default editor to nvim
export EDITOR=nvim


# Load Angular CLI autocompletion.
# source <(ng completion script)

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export NVIM_LOG_FILE=/dev/null


# External Display
alias hdmi='xrandr --output HDMI-1 --right-of eDP-1 --auto'
alias hdmioff='xrandr --output HDMI-1 --off'
