if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

source $ZSH/oh-my-zsh.sh

# aliases
alias nv=nvim
alias python=python3

# firefox
alias ff='/opt/firefox/firefox'
alias firefox=ff
alias ffs='ff --search'

alias cd..="cd .."
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

alias lock='i3lock -c 000000'

alias xc='xclip -selection clipboard'

# Brightness control
alias bu='sudo brightnessctl set 50000'
alias bd='sudo brightnessctl set 5000'

# Docker aliases
alias d3u='docker compose down && docker compose up'

# tmux aliases
alias tmk='tmux kill-session -t'

# Powerlevel10k theme
source ~/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# zoxide
eval "$(zoxide init zsh)"

# SSH agent (start only if not running)
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
  eval "$(ssh-agent -s)" >/dev/null
  ssh-add ~/.ssh/gitlab-bajra >/dev/null 2>&1
  ssh-add ~/.ssh/gitlab-local >/dev/null 2>&1
  ssh-add ~/.ssh/id_ed25519 >/dev/null 2>&1
fi

# Default editor
export EDITOR=nvim

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export NVIM_LOG_FILE=/dev/null

# External Display
alias hdmi='xrandr --output HDMI-1 --right-of eDP-1 --auto'
alias hdmioff='xrandr --output HDMI-1 --off'

# NVM setup (let it manage Node path)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Clean PATH (fixed order, no duplicates, no hardcoded node path)
export PATH="$HOME/.cargo/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:$HOME/.local/bin:/opt/nvim-linux-x86_64/bin:/opt:/usr/games:/usr/local/games:/snap/bin"

# Terminal history manager
eval "$(atuin init zsh)"

# mise
eval "$(mise activate zsh)"
