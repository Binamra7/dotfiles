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
-- A permanently reserved cmdline row: with cmdheight=0, ui2 inserts the row
-- only while a command is typed, which shifts the buffer up by one line.
vim.opt.cmdheight = 1
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
