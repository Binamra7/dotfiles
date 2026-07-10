-- General
vim.opt.clipboard = "unnamedplus" -- sync with system clipboard
vim.opt.confirm = true -- ask instead of failing on unsaved changes
vim.opt.autowrite = true
vim.opt.mouse = "" -- keyboard only
vim.opt.timeoutlen = 300
vim.opt.updatetime = 200

-- UI
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.title = true
vim.opt.scrolloff = 20
vim.opt.sidescrolloff = 8
vim.opt.laststatus = 3 -- global statusline
vim.opt.cmdheight = 0 -- no cmdline row; noice renders a floating cmdline popup
vim.opt.showmode = false -- lualine shows the mode
vim.opt.pumheight = 10
vim.opt.winborder = "rounded" -- border for all floating windows (hover, etc.)
vim.opt.conceallevel = 2
vim.opt.smoothscroll = true
vim.opt.fillchars = { eob = " " }

-- Splits
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.splitkeep = "cursor" -- keep cursor position stable when splitting

-- Editing & indentation (2-space for Ruby/JS)
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.shiftround = true
vim.opt.smartindent = true
vim.opt.wrap = true
vim.opt.breakindent = true
vim.opt.virtualedit = "block" -- allow cursor past EOL in visual block
vim.opt.completeopt = "menu,menuone,noselect"

-- Search & substitution
vim.opt.ignorecase = true
vim.opt.smartcase = true -- case-sensitive only if the search has a capital
vim.opt.inccommand = "split" -- preview :s results in a split
vim.opt.grepprg = "rg --vimgrep"
vim.opt.grepformat = "%f:%l:%c:%m"

-- Files & undo
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

-- Session contents (used by persistence.nvim)
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

-- Neovide: appearance only; cursor/scroll animations left at Neovide defaults.
-- Single font size across machines (matches ghostty's h14). The Debian/i3 box
-- previously needed a smaller pt size because winit auto-scaled ~1.48x from the
-- eDP panel's EDID DPI; that is fixed at the root with WINIT_X11_SCALE_FACTOR=1
-- (set on the `neovide` alias in .zshrc), so true scale applies everywhere.
if vim.g.neovide then
	vim.o.guifont = "JetBrainsMono Nerd Font:h14"
	vim.o.linespace = 4 -- extra px between lines; neovide's default 0 feels cramped
	vim.g.neovide_opacity = 0.9
	-- Bolder diagnostic undercurl (and all underlines). Default 1.0; >1.0
	-- thickens the stroke. Dial down toward 1.0 if the squiggle clips.
	vim.g.neovide_underline_stroke_scale = 1.8
	-- On X11 (the Debian/i3 box) neovide's winit layer auto-scales ~1.48x from
	-- the eDP panel's EDID DPI (~142 → /96), opening the GUI ~150% too big.
	-- Cancel it here in-config so the fix applies however neovide is launched
	-- (terminal, file manager, desktop entry) — WINIT_X11_SCALE_FACTOR=1 only
	-- reaches shell-launched neovide. Wayland (Hyprland/Arch) reports correct
	-- scale, so leave it at 1.0 there. Tune the divisor if a different monitor
	-- renders too big/small.
	if (vim.env.XDG_SESSION_TYPE or ""):lower() == "x11" then
		vim.g.neovide_scale_factor = 1 / 1.48
	end
end
