# dotfiles

Personal dotfiles for an **Arch Linux + Hyprland** (Wayland, NVIDIA) setup, deployed
with [GNU Stow](https://www.gnu.org/software/stow/). The repo root mirrors `$HOME`:
every tracked path (`.zshrc`, `.config/<app>/…`) is symlinked into place by running
`stow` from the repo directory. There is no build step — editing a file here edits the
live config through the symlink.

> **Branches:** this branch is the **personal Arch + Hyprland** machine. The work
> laptop (Ubuntu 24 + i3/X11) lives on a separate `bajra_dotfiles` branch — don't expect
> i3/X11 or apt tooling here.

## Quick start

```sh
git clone https://github.com/Binamra7/dotfiles ~/dotfiles
cd ~/dotfiles

# 1. Install the explicitly-installed Arch/AUR packages
paru -S --needed $(grep -v '^#' user_packages.list)

# 2. Symlink every config into $HOME
stow .

# 3. (optional) Claude Code token-optimization tooling
./scripts/install-claude-tools.sh
```

`stow -n -v .` does a dry run (shows what would change); `stow -D .` removes the symlinks.

## What's here

- `.zshrc` — Oh My Zsh + Powerlevel10k, a deduped `path` array, tool inits
  (zoxide, atuin, mise, fzf) and an SSH-agent bootstrap. **mise** manages language
  runtimes (node/ruby/go/rust) — no nvm/rbenv.
- `.config/hypr/` — Hyprland; `hyprland.conf` only `source =`s the split files in
  `config.d/` (option, monitor, env, window-rule, bind, startup). Edit those, not the
  top-level file.
- `.config/nvim/` — native Neovim 0.12 (`vim.pack` + `vim.lsp`, no plugin manager).
  See `.config/nvim/AGENTS.md` before touching it.
- `.config/{waybar,ghostty,tmux,rofi,dunst,lazygit,lsd,bat,…}` — per-app config.
  **Ghostty** is the primary terminal.
- `scripts/` — `system_maintenance.sh` (interactive Arch housekeeping; `--upgrade` for a
  full update, `--yes` for unattended) and `install-claude-tools.sh`.

## Package manifest

`user_packages.list` is the hand-maintained list of explicitly-installed Arch/AUR
packages. Refresh it after installing things with:

```sh
pacman -Qqe > user_packages.list   # then prune to the ones you actually want tracked
```

It is excluded from stow via `.stow-local-ignore` (it's documentation, not a config).

## Notes for contributors / agents

`CLAUDE.md` (repo root) is the agent/developer guide. It and the other Claude tooling
files are tracked in git but excluded from `stow` (see `.stow-local-ignore`) so they
never get symlinked into `$HOME`.
