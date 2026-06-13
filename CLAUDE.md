# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Personal dotfiles, deployed with **GNU Stow**. The repo root mirrors `$HOME`: every
tracked path (`.zshrc`, `.config/<app>/…`) is symlinked into place by running `stow`
from the repo directory. There is no build step — editing a file here edits the live
config through the symlink.

```sh
stow .            # (re)create symlinks from repo root into $HOME
stow -D .         # remove the symlinks
stow -n -v .      # dry-run; show what would change
```

`.stow-local-ignore` keeps the package-manifest files (`*packages.list`) from being
stowed — they are documentation/backups, not configs.

## Two target machines

The repo is shared across an Arch (primary) and a Debian/Ubuntu host, so it carries
both ecosystems. Be careful not to assume one when editing shared files:

- **Arch + Hyprland (Wayland, NVIDIA)** — the active desktop. `user_packages.list` is
  the hand-maintained list of explicitly-installed Arch/AUR packages (paru/yay).
- **Debian/Ubuntu + i3 (X11)** — `apt_packages.list` is the hand-maintained apt list;
  `packages.list` is a full `dpkg --get-selections` dump (3000+ lines, backup only).

The repo is mid-migration from i3/X11 to Hyprland/Wayland — i3/i3status configs are
being removed. Prefer Wayland tooling (`wl-copy`, `hyprctl`, `brightnessctl`, `waybar`)
in new work.

## Layout

- `.config/<app>/` — per-application config (hypr, waybar, nvim, tmux, ghostty, kitty,
  rofi, dunst, lazygit, lsd, bat, picom, flameshot, …).
- `.zshrc` — single zsh entrypoint: Oh My Zsh + Powerlevel10k (sourced manually, not via
  `ZSH_THEME`), `path` array with `typeset -U` for idempotent reloads, then tool inits
  (`zoxide`, `atuin`, `mise`, `fzf`) and an SSH-agent bootstrap. **mise** manages
  language runtimes (node/ruby/go/rust) — there is no nvm/rbenv.
- `scripts/system_maintenance.sh` — interactive Arch housekeeping (cache trim, orphan
  removal, `~/.cache` prune, journald vacuum). Run with `--upgrade` to also do a full
  `paru`/`yay -Syu`. Auto-detects the AUR helper. Logs to `~/.local/var/log/`.
- `scripts/install-claude-tools.sh` — idempotent, cross-distro (Arch + Debian) installer
  for Claude Code token-optimization tools: rtk (`rtk-ai/rtk` CLI hook), karpathy (CC
  plugin via `claude plugin`), graphify (Python CLI + skill/hook via pipx). Runs all by
  default; takes tool names to select, or `--skip <tool>`. Each tool is independent —
  failures are reported and skipped, not fatal. Verify-only flags: `--list`, `--help`.

## Hyprland config

`.config/hypr/hyprland.conf` only `source =`s the split files in `config.d/`
(`option`, `monitor`, `env`, `window-rule`, `bind`, `startup`) plus NVIDIA-specific env
and cursor settings. Edit the relevant `config.d/*.conf` file, not the top-level one,
for keybinds/rules/startup. Hyprland reloads config live on save.

## Neovim

`.config/nvim/` is a fully native Neovim 0.12 setup (`vim.pack` for plugins,
`vim.lsp.config`/`vim.lsp.enable` for LSP — no plugin manager). **Read
`.config/nvim/AGENTS.md` before touching anything under `.config/nvim/`** — it documents
the load order, keymap policy (all global maps in `config/keymaps.lua`), the vim.pack
workflow (`:PackUpdate`, committed `nvim-pack-lock.json`), ruby-lsp-via-mise quirks, and
headless testing. That file is the source of truth for this subtree.
