local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Better Escape
keymap.set("i", "jk", "<ESC>", opts)

-- Move lines (Bubbling)
-- Uses the move command which is more stable than :m
keymap.set("n", "<A-j>", "<cmd>m .+1<cr>==", opts)
keymap.set("n", "<A-k>", "<cmd>m .-2<cr>==", opts)
keymap.set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", opts)
keymap.set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", opts)
keymap.set("v", "<A-j>", ":m '>+1<cr>gv=gv", opts)
keymap.set("v", "<A-k>", ":m '<-2<cr>gv=gv", opts)

-- Register management (Black hole deletions)
keymap.set("n", "x", '"_x')
keymap.set({ "n", "v" }, "<Leader>d", '"_d')
keymap.set({ "n", "v" }, "<Leader>D", '"_D')
keymap.set({ "n", "v" }, "<Leader>c", '"_c')

-- Paste logic: Keep the yanked text after pasting over a selection
keymap.set("v", "p", '"_dP', opts) -- The ultimate "don't lose my yank" map
keymap.set("n", "<Leader>p", '"0p', opts) -- Paste specifically from yank register

-- Select all
-- keymap.set("n", "<C-a>", "ggVG", opts)

-- Disable newline continuation comments
-- This is a cleaner way to get a new line without auto-commenting
keymap.set("n", "<Leader>o", "o<C-u>", { desc = "New line below" })
keymap.set("n", "<Leader>O", "O<C-u>", { desc = "New line above" })

-- Window Management
-- LazyVim uses <C-hjkl> by default, but if you like 's' prefixes:
keymap.set("n", "ss", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)
keymap.set("n", "sh", "<C-w>h")
keymap.set("n", "sk", "<C-w>k")
keymap.set("n", "sj", "<C-w>j")
keymap.set("n", "sl", "<C-w>l")

-- Resizing with arrows
keymap.set("n", "<C-w><left>", "<C-w><", opts)
keymap.set("n", "<C-w><right>", "<C-w>>", opts)
keymap.set("n", "<C-w><up>", "<C-w>+", opts)
keymap.set("n", "<C-w><down>", "<C-w>-", opts)
