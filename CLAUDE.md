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

## This branch / target machine

**This is the `bajra_dotfiles` branch: a Debian/Ubuntu + i3 (X11) work PC.** Package
management is **apt/apt-get** — `apt_packages.list` is the hand-maintained list of
explicitly-installed apt packages; `packages.list` is a full `dpkg --get-selections`
dump (backup only, large). Prefer X11/i3 tooling (`xclip`/`xsel`, `i3-msg`, `xrandr`,
i3status) in new work.

> The repo is shared with a separate `personal-vibe-coded-dotfiles` branch — an
> Arch + Hyprland (Wayland, NVIDIA) host that uses paru/yay and `user_packages.list`.
> Don't assume pacman/AUR or Hyprland/Wayland tooling on this branch.

## Layout

- `.config/<app>/` — per-application config (i3, nvim, tmux, ghostty, rofi, lazygit,
  lsd, …).
- `.zshrc` — single zsh entrypoint: Oh My Zsh + Powerlevel10k (sourced manually, not via
  `ZSH_THEME`), `path` array with `typeset -U` for idempotent reloads, then tool inits
  (`zoxide`, `atuin`, `mise`, `fzf`) and an SSH-agent bootstrap. **mise** manages
  language runtimes (node/ruby/go/rust) — there is no nvm/rbenv.
- `scripts/system_maintenance.sh` — interactive Ubuntu/Debian housekeeping (apt cache
  trim, `apt-get autoremove`, `~/.cache` prune, journald vacuum). Run with `--upgrade`
  to also do a full `apt-get update && full-upgrade`. Logs to `~/.local/var/log/`.
- `scripts/install-claude-tools.sh` — idempotent, cross-distro (Arch + Debian) installer
  for Claude Code token-optimization tools: rtk (`rtk-ai/rtk` CLI hook), karpathy (CC
  plugin via `claude plugin`), graphify (Python CLI + skill/hook via pipx). Runs all by
  default; takes tool names to select, or `--skip <tool>`. Each tool is independent —
  failures are reported and skipped, not fatal. Verify-only flags: `--list`, `--help`.

## Hyprland (Lua config)

Hyprland >= 0.55 deprecates hyprlang (`.conf`) in favour of Lua; the config is
`.config/hypr/hyprland.lua`, which `require`s `conf/{option,monitor,env,window_rule,bind,startup}.lua`
(dir is `conf/`, not `config.d/` — a dot in a `require` name is a path separator). The legacy
`hyprland.conf` + `config.d/*.conf` were removed (recoverable from git history before commit `89c38ef3`).
`hypridle.conf`, `hyprlock.conf`, `hyprpaper.conf` stay hyprlang (those programs have no Lua support).

- Validate before reloading: `Hyprland --verify-config -c ~/.config/hypr/hyprland.lua` — exit code is
  always 0, pass = output contains `config ok`. It runs the file, so never call `hl.exec_cmd` outside
  the `hl.on("hyprland.start", ...)` handler. Errors inside bind callbacks only appear on keypress.
- Apply: `hyprctl reload`.
  Check `hyprctl configerrors`. `hyprctl eval '<lua>'` works only under the Lua config.
- `hyprctl dispatch` now takes a Lua expr (`hyprctl dispatch 'hl.dsp.dpms({ action = "off" })'`),
  and `hyprctl keyword` is refused — use `hyprctl eval`. Callers already converted: `hypridle.conf`,
  waybar workspace scroll, `hdmi`/`hdmioff` aliases in `.zshrc`.
- API reference: `/usr/share/hypr/stubs/hl.meta.lua` and `/usr/share/hypr/hyprland.lua` (installed with
  Hyprland; the wiki tracks git main and can disagree with the installed version).
- Gotchas: `resizeactive exact 50% 50%` has no Lua form (`SUPER+equal` computes it from the monitor
  size); `hl.dsp.reload_config` is absent in 0.56.2 (reload bind uses `exec_cmd("hyprctl reload")`);
  strings with `\n` need `[[...]]` long strings; mods are uppercase (`SUPER + SHIFT + x`).

## Neovim

`.config/nvim/` is a Neovim setup. Read any `.config/nvim/AGENTS.md` (if present) before
touching anything under `.config/nvim/` — it documents the load order, keymap policy, and
plugin workflow, and is the source of truth for that subtree.

## graphify

This project has a knowledge graph at graphify-out/ with god nodes, community structure, and cross-file relationships.

Rules:
- For codebase questions, first run `graphify query "<question>"` when graphify-out/graph.json exists. Use `graphify path "<A>" "<B>"` for relationships and `graphify explain "<concept>"` for focused concepts. These return a scoped subgraph, usually much smaller than GRAPH_REPORT.md or raw grep output.
- If graphify-out/wiki/index.md exists, use it for broad navigation instead of raw source browsing.
- Read graphify-out/GRAPH_REPORT.md only for broad architecture review or when query/path/explain do not surface enough context.
- After modifying code, run `graphify update .` to keep the graph current (AST-only, no API cost).
