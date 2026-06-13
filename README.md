# dotfiles

Personal dotfiles for an **Ubuntu + i3** (X11) setup, deployed with
[GNU Stow](https://www.gnu.org/software/stow/). The repo root mirrors `$HOME`:
every tracked path (`.zshrc`, `.config/<app>/…`) is symlinked into place by running
`stow` from the repo directory. There is no build step — editing a file here edits the
live config through the symlink.

> **Branches:** this branch (`bajra_dotfiles`) is the **work Ubuntu + i3/X11** machine.
> The personal desktop (Arch + Hyprland/Wayland, NVIDIA) lives on a separate
> `personal-vibe-coded-dotfiles` branch — don't expect Hyprland/Wayland or pacman/AUR
> tooling here.

## Quick start

```sh
git clone https://github.com/Binamra7/dotfiles ~/dotfiles
cd ~/dotfiles

# 1. Install the explicitly-installed apt packages
sudo apt-get install $(grep -v '^#' apt_packages.list)

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
- `.config/i3/` — i3 window manager config (X11).
- `.config/nvim/` — Neovim config. See `.config/nvim/AGENTS.md` (if present) before
  touching it.
- `.config/{ghostty,tmux,rofi,lazygit,lsd,…}` — per-app config.
  **Ghostty** is the primary terminal.
- `scripts/` — `system_maintenance.sh` (interactive Ubuntu/Debian housekeeping;
  `--upgrade` for a full apt update, `--yes` for unattended) and
  `install-claude-tools.sh`.

## Package manifest

`apt_packages.list` is the hand-maintained list of explicitly-installed apt packages.
Refresh it after installing things with:

```sh
apt-mark showmanual > apt_packages.list   # then prune to the ones you actually want tracked
```

(`packages.list` is a full `dpkg --get-selections` dump kept as a backup.) Both are
excluded from stow via `.stow-local-ignore` (they're documentation, not configs).

## Notes for contributors / agents

`CLAUDE.md` (repo root) is the agent/developer guide. It and the other Claude tooling
files are tracked in git but excluded from `stow` (see `.stow-local-ignore`) so they
never get symlinked into `$HOME`.
