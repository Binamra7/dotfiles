# Neovim Config — Agent Reference

Context for AI agents modifying this config. Migrated from LazyVim/lazy.nvim
to **fully native Neovim 0.12** (June 2026): `vim.pack` for plugins,
`vim.lsp.config`/`vim.lsp.enable` for LSP. No plugin manager plugins.

## Environment

- Neovim 0.12.x on Arch Linux, terminal with tmux (user relies on tmux, not nvim terminals)
- Ruby via **mise** (`~/.local/share/mise/installs/ruby/latest`); `ruby-lsp` is a gem there, NOT a mason package
- Mason is used ONLY as a binary installer (no mason-lspconfig); needs `unzip` on the system
- Main work: Ruby on Rails (ruby-lsp) and Angular/TypeScript (vtsls + angularls)

## File layout & load order

`init.lua` requires, in order (order matters):

1. `lua/config/options.lua` — only deviations from defaults; each has a comment
2. `lua/config/keymaps.lua` — **single registry for ALL global keymaps** (see policy below)
3. `lua/config/autocmds.lua` — yank highlight, last-loc, q-to-close, conceal
4. `lua/plugins/init.lua` — `vim.pack.add()` manifest + `PackChanged` build hooks + `:PackUpdate` command, then requires `plugins/{ui,treesitter,editor,coding}.lua` (pure setup, no global keymaps)
5. `lua/config/lsp.lua` — mason ensure-installed, diagnostics config, `vim.lsp.enable`, LspAttach buffer keymaps
- `lsp/<server>.lua` — per-server overrides, auto-merged with nvim-lspconfig's definitions (native `:h lsp-config` convention)
- `.luarc.json` — lua_ls settings for editing this config (replaces lazydev)

## Keymap policy

ALL global mappings live in `config/keymaps.lua`, organized by section; callbacks
`require()` plugins lazily so the file loads before plugins. Plugin files contain
only buffer-local/internal keys (gitsigns `on_attach`, oil/copilot/blink/diffview
internal tables). LSP `gd/gr/gI/gy` are buffer-local, set on LspAttach in
`config/lsp.lua`. Leader = space. Conventions the user is attached to:
`;`-prefix = telescope pickers, `s`-prefix = windows/split + `sf` file browser,
`jk` = escape, `f` = flash jump, `S` = flash treesitter, `q` closes utility
windows (autocmd + diffview keymaps + gitsigns-blame filetype).

## Plugin management (vim.pack)

- Add: append spec to `vim.pack.add()` list in `plugins/init.lua` + setup call in the right `plugins/*.lua`. GitHub URLs via local `gh()` helper. catppuccin needs `name = "catppuccin"` (repo is named `nvim`).
- Remove: delete from list, then `vim.pack.del({ "name" })` (or rm the dir under `~/.local/share/nvim/site/pack/core/opt/`)
- Update: `:PackUpdate`; lockfile `nvim-pack-lock.json` is committed
- Build steps run via the `PackChanged` autocmd (fzf-native `make`, treesitter `update()`)
- blink.cmp is pinned `version = vim.version.range("1.*")` so it checks out release tags → downloads its prebuilt Rust fuzzy lib. Don't switch it to a branch.

## LSP

- Servers enabled in `config/lsp.lua`: `ruby_lsp`, `vtsls`, `angularls`, `cssls`, `tailwindcss`, `yamlls`, `lua_ls`
- Add a server: `vim.lsp.enable` entry + (if mason-installable) `mason_tools` entry + optional `lsp/<name>.lua` override
- **ruby-lsp, not solargraph.** Solargraph was removed (slow multi-minute gem indexing blocked requests, spammed progress notifications, and its mason gem binstubs broke on every mise Ruby upgrade). First open of a project takes a while to compose its bundle, then instant. Rails `scope`-generated methods are statically unresolvable — "no definition" for those is expected, not a bug.
- **ruby-lsp launches via `mise x -- ruby-lsp --use-launcher`** (explicit `vim.lsp.config()` call in `config/lsp.lua`). `--use-launcher` is essential: the user runs Rails apps in **Docker**, so project gems are often not installed locally — the launcher boots gracefully anyway (project-code navigation works; jumping into gem source needs gems installed locally and is expected to be unavailable). Don't remove the flag, and don't "fix" failed composed-bundle installs by demanding local `bundle install`. so it runs under the project's Ruby (`.ruby-version` — idiomatic version files are enabled for ruby in mise settings). Plain `ruby-lsp` ran under mise `latest` and crashed with `Bundler::RubyVersionMismatch` in projects pinning an older Ruby. The ruby-lsp gem must be installed in EACH mise Ruby (`~/.local/share/mise/installs/ruby/<ver>/bin/gem install ruby-lsp`); resolution uses nvim's cwd, so open nvim from the project root. If a project's composed bundle gets corrupted, delete its `.ruby-lsp/` dir.
- **GOTCHA: a user `lsp/<name>.lua` file does NOT reliably override nvim-lspconfig's file for the same key** — for conflicting keys (e.g. `cmd`), the plugin's file (later in runtimepath) wins the merge. User `lsp/` files are fine for *adding* settings (vtsls/yamlls/angularls here). For hard overrides, use an explicit `vim.lsp.config("name", {...})` call in `config/lsp.lua` — those outrank all files.
- **GOTCHA: never gate LspAttach keymaps on `client:supports_method()`** — ruby servers register capabilities dynamically *after* attach; the check returns false at attach time and silently skips the mapping. This broke `gd` once already.
- vtsls carries the Angular global plugin wiring in `lsp/vtsls.lua` (points into mason's angular-language-server package)

## UI decisions (and rejected alternatives)

- **noice is kept deliberately, only for the cmdline popup + message routing.** Native ui2 (`vim._core.ui2` in this build — NOT `vim._extui`) was tried and rejected: with `cmdheight=0` it hardcodes a temporary `cmdheight=1` while typing `:`, shifting the buffer; `cmdheight=1` wastes a row above the tmux bar. User wants neither. Revisit ui2 only when it can float the cmdline without touching cmdheight.
- `cmdheight=0`; notifications via snacks notifier (noice's "snacks" backend picks it up automatically)
- catppuccin mocha, transparent; lualine theme is `"auto"` (catppuccin only ships `catppuccin-<flavour>` lualine themes now, no plain `catppuccin`)
- lualine has a custom macro-recording component (`recording @x`, red) with `RecordingEnter/Leave` refresh autocmds — the statusline doesn't redraw on its own when recording starts
- which-key: helix preset; user relies on the leader popup for discovery
- Animations: smear-cursor.nvim (tuned to mimic Neovide's stretchy cursor) + snacks scroll in the terminal; both are gated off under Neovide (`vim.g.neovide`), which animates natively via `vim.g.neovide_*` in `config/options.lua`. Don't enable them under Neovide — animations double up.

## Formatting (conform)

- `format_on_save` honors `vim.g.autoformat` / `vim.b.autoformat` (toggle: `<leader>tf`)
- ruby → rubocop with `--server`, gated on a project `.rubocop.yml`; binary comes from mise/bundle PATH (mason's rubocop was uninstalled — it auto-started as a broken LSP under mason-lspconfig v2 semantics and its binstub broke on Ruby upgrades)
- web filetypes → prettier (mason), lua → stylua (mason). Format this config with mason's stylua (default config, tabs).

## Treesitter (main branch API)

`nvim-treesitter` is on `main` (the rewrite) — there is NO `configs` module, no
`highlight.enable` opts. Parser list + `TS.install()` + a `FileType` autocmd
calling `vim.treesitter.start()` and setting `indentexpr` live in
`plugins/treesitter.lua`. ERB parser is `embedded_template` (not "erb").
Incremental selection no longer exists upstream; flash `S` covers it.

## Testing changes headlessly

```sh
nvim --headless FILE "+lua vim.defer_fn(function() ... vim.cmd('qa!') end, 15000)"
```

- **`print()` does not reach stdout** — noice owns ext_messages. Write results to a temp file instead.
- Check notifications: `Snacks.notifier.get_history()`
- Check LSP: `vim.lsp.get_clients()`; ruby-lsp needs ~30s warmup in a fresh project
- Lua trap that bit before: `table.insert(t, s:gsub(...))` passes gsub's 2nd return value and throws — wrap the gsub in parens

## History / removed things

- Removed vs LazyVim: trouble, grug-far, mini.ai, lazydev, noice's message views (kept cmdline), `<leader>u*` toggle family (`<leader>u` = undotree here). todo-comments was re-added later (`;d` picker, `]t`/`[t`).
- Old lazy.nvim plugin data may still exist at `~/.local/share/nvim/lazy` (unused, deletable)
- diffview.nvim + gitsigns blame replaced LazyVim's git pickers; `<leader>gd` toggles diffview, `<leader>gb` is per-line blame
