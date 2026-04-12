vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Neovim defaults to utf-8; these are usually redundant but harmless
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

-- UI & Gutter
vim.opt.number = true
vim.opt.title = true
vim.opt.mouse = ""
vim.opt.scrolloff = 20
vim.opt.laststatus = 3 -- Global statusline (better for splits)
vim.opt.cmdheight = 0  -- Hides command line when not in use
vim.opt.showcmd = true

-- Search Logic
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true     -- Search is case-sensitive if it contains a capital
vim.opt.inccommand = "split" -- Preview substitutions in a split window

-- copy between nvim and other applications
vim.opt.clipboard = "unnamedplus"

-- Indentation (Tailored for Ruby/JS)
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smarttab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.breakindent = true
vim.opt.wrap = true

-- Window Splitting
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.splitkeep = "cursor" -- Keeps text stationary when splitting

-- File Handling & Path
vim.opt.path:append({ "**" })
vim.opt.wildignore:append({ "*/node_modules/*", "*/vendor/*", "*/.git/*", "*/tmp/*" })

-- Filesystem Safety (The "Quiet" Settings)
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.undofile = true -- saves undo history after closing Neovim!
vim.opt.backupskip = { "/tmp/*", "/private/tmp/*" }

-- Formatting & System
vim.opt.formatoptions:append({ "r" }) -- Auto-add asterisks in comments
vim.opt.shell = "zsh"
vim.opt.backspace = { "start", "eol", "indent" }

-- Undercurl Support (for modern terminals)
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])
