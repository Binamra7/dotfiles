# =============================================================================
# Powerlevel10k instant prompt — must stay near the top of .zshrc.
# =============================================================================
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# =============================================================================
# Oh My Zsh
# =============================================================================
export ZSH="$HOME/.oh-my-zsh"
# Theme is left empty: Powerlevel10k is sourced manually below, so loading an
# OMZ theme here would just be discarded.
ZSH_THEME=""
source "$ZSH/oh-my-zsh.sh"

# =============================================================================
# History — override Oh My Zsh's defaults (it sets HISTFILE + share_history).
# Interactive search/up-arrow are handled by atuin (init'd below); these govern
# the raw $HISTFILE that atuin imports from and the in-shell `history` builtin.
# =============================================================================
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_ALL_DUPS   # a repeated command removes its older duplicate
setopt HIST_REDUCE_BLANKS     # strip superfluous whitespace before saving
setopt HIST_IGNORE_SPACE      # a leading space keeps a command out of history

# =============================================================================
# Environment
# =============================================================================
export EDITOR=nvim
export NVIM_LOG_FILE=/dev/null

# PATH — zsh `path` array with `typeset -U` keeps entries unique (idempotent
# across `reload!`) instead of clobbering the inherited PATH. cargo takes
# priority over system dirs; the rest are appended after them. Tool shims
# (mise, atuin, …) are prepended later, so they win over everything here.
typeset -U path PATH
path=(
  "$HOME/.cargo/bin"
  $path
  "$HOME/.local/bin"
  /opt/nvim-linux-x86_64/bin
  /opt
  /usr/games
  /usr/local/games
  /snap/bin
)

# =============================================================================
# Aliases
# =============================================================================
alias nv=nvim
alias python=python3
alias cd..='cd ..'
alias reload!='source ~/.zshrc'
alias sudo='sudo '            # trailing space lets the next word be alias-expanded

# Firefox
alias ff='/opt/firefox/firefox'
alias firefox=ff
alias ffs='ff --search'

# Listing (lsd — defaults like icons/relative-date/dir-grouping live in
# ~/.config/lsd/config.yaml, so these stay thin)
alias ls='lsd'
alias l='lsd -l'                  # long
alias ll='lsd -l'                 # long
alias la='lsd -lA'                # long, almost-all (hide . and ..)
alias lla='lsd -la'               # long, all (include . and ..)
alias lr='lsd -R'                 # recursive
alias lra='lsd -laR'              # recursive, all
alias lt='lsd -lt'                # newest first
alias lz='lsd -lS'                # largest first
alias lss='lsd -l --total-size'   # long, with directory total sizes
alias ltree='lsd --tree'          # tree view
alias ltreea='lsd --tree -a'      # tree view, all
alias lt2='lsd --tree --depth 2'  # tree, limited to 2 levels

# Clipboard (Wayland)
alias xc='wl-copy'
alias copy='wl-copy <'

# Screen lock (Hyprland)
alias lock='hyprlock'

# Brightness control (brightnessctl needs no sudo with the standard udev rules)
alias bu='brightnessctl set 50%'
alias bd='brightnessctl set 5%'

# External display (Hyprland). Adjust the output name to match
# `hyprctl monitors all` if your HDMI port reports something other than HDMI-A-1.
alias hdmi='hyprctl keyword monitor "HDMI-A-1,preferred,auto-right,1"'
alias hdmioff='hyprctl keyword monitor "HDMI-A-1,disable"'

# Docker
alias d3u='docker compose down && docker compose up'

# tmux
alias tmk='tmux kill-session -t'

# =============================================================================
# Tool initialization
# =============================================================================
eval "$(zoxide init zsh)"
eval "$(atuin init zsh)"
eval "$(mise activate zsh)"   # manages node, ruby, go, rust, … (replaces nvm)
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# =============================================================================
# SSH agent — start once per session and load keys.
# =============================================================================
# Reuse an inherited agent if SSH_AUTH_SOCK is already set, or one this user is
# already running; only spawn a fresh agent (and load keys) otherwise.
if [[ -z "${SSH_AUTH_SOCK:-}" ]] && ! pgrep -u "$USER" ssh-agent >/dev/null; then
  eval "$(ssh-agent -s)" >/dev/null
  for key in "$HOME"/.ssh/id_* "$HOME"/.ssh/gitlab-*; do
    [[ -f "$key" && "$key" != *.pub ]] && ssh-add "$key" >/dev/null 2>&1
  done
fi

# =============================================================================
# Powerlevel10k prompt — keep last.
# =============================================================================
source "$HOME/powerlevel10k/powerlevel10k.zsh-theme"
[[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"
