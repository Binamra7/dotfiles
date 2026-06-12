local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Better Escape
keymap.set("i", "jk", "<ESC>", opts)

-- Clear search highlight
keymap.set({ "n", "i" }, "<Esc>", "<cmd>nohlsearch<cr><Esc>", { desc = "Clear hlsearch" })

-- Save
keymap.set({ "n", "i", "x" }, "<C-s>", "<cmd>w<cr><Esc>", { desc = "Save File" })

-- Move lines (Bubbling)
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

-- Paste logic: keep the yanked text after pasting over a selection
keymap.set("v", "p", '"_dP', opts)
keymap.set("n", "<Leader>p", '"0p', opts) -- paste from yank register

-- New line without continuing comments
keymap.set("n", "<Leader>o", "o<C-u>", { desc = "New line below" })
keymap.set("n", "<Leader>O", "O<C-u>", { desc = "New line above" })

-- Window navigation
keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window" })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window" })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window" })

-- Window Management ('s' prefix; native s is freed since flash only maps f/S)
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

-- Buffers
keymap.set("n", "<Tab>", "<Cmd>BufferLineCycleNext<CR>", { desc = "Next Buffer" })
keymap.set("n", "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Prev Buffer" })
keymap.set("n", "<S-l>", "<Cmd>BufferLineCycleNext<CR>", { desc = "Next Buffer" })
keymap.set("n", "<S-h>", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Prev Buffer" })
keymap.set("n", "<leader>bd", function()
	Snacks.bufdelete()
end, { desc = "Delete Buffer" })
keymap.set("n", "<leader>th", function()
	-- close all hidden (not displayed, unmodified) buffers
	local visible = {}
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		visible[vim.api.nvim_win_get_buf(win)] = true
	end
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if not visible[buf] and vim.bo[buf].buflisted and not vim.bo[buf].modified then
			vim.api.nvim_buf_delete(buf, {})
		end
	end
end, { desc = "Close Hidden Buffers" })

-- Pickers (LazyVim muscle-memory bindings)
keymap.set("n", "<leader><leader>", function()
	require("telescope.builtin").find_files({ hidden = true })
end, { desc = "Find Files" })
keymap.set("n", "<leader>/", function()
	require("telescope.builtin").live_grep({ additional_args = { "--hidden" } })
end, { desc = "Grep" })
keymap.set("n", "<leader>fr", function()
	require("telescope.builtin").oldfiles()
end, { desc = "Recent Files" })
keymap.set("n", "<leader>e", function()
	Snacks.explorer()
end, { desc = "File Explorer" })
keymap.set("n", "<leader>n", function()
	Snacks.notifier.show_history()
end, { desc = "Notification History" })

-- LSP (leader forms; gra/grn/grr natives also work)
keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })

-- Diagnostics
keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
keymap.set("n", "]e", function()
	vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
end, { desc = "Next Error" })
keymap.set("n", "[e", function()
	vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR })
end, { desc = "Prev Error" })

-- Toggle format-on-save (was LazyVim's <leader>uf)
keymap.set("n", "<leader>tf", function()
	vim.g.autoformat = vim.g.autoformat == false
	vim.notify("Format on save: " .. (vim.g.autoformat ~= false and "on" or "off"))
end, { desc = "Toggle Format on Save" })

-- Quit all
keymap.set("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })

-- Git (snacks)
keymap.set("n", "<leader>gg", function()
	Snacks.lazygit()
end, { desc = "Lazygit" })
keymap.set("n", "<leader>gb", "<cmd>Gitsigns blame<cr>", { desc = "Blame Buffer (author per line)" })
keymap.set("n", "<leader>gl", function()
	Snacks.git.blame_line()
end, { desc = "Blame Line (popup)" })
keymap.set({ "n", "x" }, "<leader>go", function()
	Snacks.gitbrowse()
end, { desc = "Open in Browser" })
keymap.set("n", "<leader>gd", function()
	-- toggle diffview
	if next(require("diffview.lib").views) then
		vim.cmd("DiffviewClose")
	else
		vim.cmd("DiffviewOpen")
	end
end, { desc = "Diff View (toggle)" })
keymap.set("n", "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", { desc = "File History" })
keymap.set("n", "<leader>tb", "<cmd>Gitsigns toggle_current_line_blame<cr>", { desc = "Toggle Inline Blame" })

-- Session
keymap.set("n", "<leader>qs", function()
	require("persistence").load()
end, { desc = "Restore Session" })
