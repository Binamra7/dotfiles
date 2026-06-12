-- Single registry for all global keymaps. Buffer-local maps live with their
-- plugin setup (gitsigns on_attach, oil/copilot/blink internal keymaps).
-- Callbacks require() plugins lazily, so this file can load before plugins.

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

local function builtin()
	return require("telescope.builtin")
end

-- Core editing ---------------------------------------------------------------

keymap.set("i", "jk", "<ESC>", opts) -- better escape
keymap.set({ "n", "i" }, "<Esc>", "<cmd>nohlsearch<cr><Esc>", { desc = "Clear hlsearch" })
keymap.set({ "n", "i", "x" }, "<C-s>", "<cmd>w<cr><Esc>", { desc = "Save File" })
keymap.set("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })

-- Move lines (bubbling)
keymap.set("n", "<A-j>", "<cmd>m .+1<cr>==", opts)
keymap.set("n", "<A-k>", "<cmd>m .-2<cr>==", opts)
keymap.set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", opts)
keymap.set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", opts)
keymap.set("v", "<A-j>", ":m '>+1<cr>gv=gv", opts)
keymap.set("v", "<A-k>", ":m '<-2<cr>gv=gv", opts)

-- Black hole deletions
keymap.set("n", "x", '"_x')
keymap.set({ "n", "v" }, "<Leader>d", '"_d')
keymap.set({ "n", "v" }, "<Leader>D", '"_D')
keymap.set({ "n", "v" }, "<Leader>c", '"_c')

-- Paste without losing the yank
keymap.set("v", "p", '"_dP', opts)
keymap.set("n", "<Leader>p", '"0p', opts) -- paste from yank register

-- New line without continuing comments
keymap.set("n", "<Leader>o", "o<C-u>", { desc = "New line below" })
keymap.set("n", "<Leader>O", "O<C-u>", { desc = "New line above" })

-- Increment/decrement (dial.nvim: bools, dates, semver, let/const)
keymap.set("n", "<C-a>", function()
	return require("dial.map").inc_normal()
end, { expr = true, desc = "Increment" })
keymap.set("n", "<C-x>", function()
	return require("dial.map").dec_normal()
end, { expr = true, desc = "Decrement" })

-- Windows --------------------------------------------------------------------

keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window" })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window" })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window" })

-- 's' prefix (native s is free: flash only maps f/S)
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

-- Buffers ----------------------------------------------------------------

keymap.set("n", "<Tab>", "<Cmd>BufferLineCycleNext<CR>", { desc = "Next Buffer" })
keymap.set("n", "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Prev Buffer" })
keymap.set("n", "<S-l>", "<Cmd>BufferLineCycleNext<CR>", { desc = "Next Buffer" })
keymap.set("n", "<S-h>", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Prev Buffer" })
keymap.set("n", "<leader>bd", function()
	Snacks.bufdelete()
end, { desc = "Delete Buffer" })

local function close_hidden_buffers()
	local visible = {}
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		visible[vim.api.nvim_win_get_buf(win)] = true
	end
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if not visible[buf] and vim.bo[buf].buflisted and not vim.bo[buf].modified then
			vim.api.nvim_buf_delete(buf, {})
		end
	end
end
keymap.set("n", "<leader>th", close_hidden_buffers, { desc = "Close Hidden Buffers" })

-- Pickers (telescope) -------------------------------------------------------

keymap.set("n", ";f", function()
	builtin().find_files({ hidden = true })
end, { desc = "Find Files" })
keymap.set("n", "<leader><leader>", function()
	builtin().find_files({ hidden = true })
end, { desc = "Find Files" })
keymap.set("n", ";r", function()
	builtin().live_grep({ additional_args = { "--hidden" } })
end, { desc = "Live Grep" })
keymap.set("n", "<leader>/", function()
	builtin().live_grep({ additional_args = { "--hidden" } })
end, { desc = "Grep" })
keymap.set("n", "\\\\", function()
	builtin().buffers()
end, { desc = "Buffers" })
keymap.set("n", ";t", function()
	builtin().help_tags()
end, { desc = "Help Tags" })
keymap.set("n", ";;", function()
	builtin().resume()
end, { desc = "Resume Last Picker" })
keymap.set("n", ";e", function()
	builtin().diagnostics()
end, { desc = "Diagnostics" })
keymap.set("n", ";s", function()
	builtin().treesitter()
end, { desc = "Treesitter Symbols" })
keymap.set("n", ";c", function()
	builtin().lsp_incoming_calls()
end, { desc = "LSP Incoming Calls" })
keymap.set("n", "<leader>fr", function()
	builtin().oldfiles()
end, { desc = "Recent Files" })
keymap.set("n", "<leader>fP", function()
	builtin().find_files({ cwd = vim.fn.stdpath("data") .. "/site/pack/core/opt" })
end, { desc = "Find Plugin File" })
keymap.set("n", ";d", "<cmd>TodoTelescope<cr>", { desc = "Todo Comments" })
keymap.set("n", "]t", function()
	require("todo-comments").jump_next()
end, { desc = "Next Todo Comment" })
keymap.set("n", "[t", function()
	require("todo-comments").jump_prev()
end, { desc = "Prev Todo Comment" })
keymap.set("n", "sf", function()
	require("telescope").extensions.file_browser.file_browser({
		path = "%:p:h",
		cwd = vim.fn.expand("%:p:h"),
		respect_gitignore = false,
		hidden = true,
		grouped = true,
		previewer = false,
		initial_mode = "normal",
		layout_config = { height = 40, prompt_position = "top" },
	})
end, { desc = "Open File Browser" })

-- Files & navigation ----------------------------------------------------

keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory in Oil" })
keymap.set("n", "<leader>e", function()
	Snacks.explorer()
end, { desc = "File Explorer" })
keymap.set({ "n", "x", "o" }, "f", function()
	require("flash").jump()
end, { desc = "Flash" })
keymap.set({ "n", "x", "o" }, "S", function()
	require("flash").treesitter()
end, { desc = "Flash Treesitter" })

-- Git ------------------------------------------------------------------------

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

-- LSP & diagnostics (gd/gr/gI/gy are buffer-local, set on LspAttach in
-- config/lsp.lua; grn/gra/grr are nvim defaults) -----------------------------

keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })
keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
keymap.set("n", "]e", function()
	vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
end, { desc = "Next Error" })
keymap.set("n", "[e", function()
	vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR })
end, { desc = "Prev Error" })
keymap.set({ "n", "v" }, "<leader>cf", function()
	require("conform").format({ lsp_format = "fallback" })
end, { desc = "Format" })

-- Toggles & misc -------------------------------------------------------------

keymap.set("n", "<leader>tf", function()
	vim.g.autoformat = vim.g.autoformat == false
	vim.notify("Format on save: " .. (vim.g.autoformat ~= false and "on" or "off"))
end, { desc = "Toggle Format on Save" })
keymap.set("n", "<leader>tb", "<cmd>Gitsigns toggle_current_line_blame<cr>", { desc = "Toggle Inline Blame" })
keymap.set("n", "<leader>u", function()
	require("undotree").toggle()
end, { desc = "Undotree" })
keymap.set("n", "<leader>z", "<cmd>ZenMode<cr>", { desc = "Zen Mode" })
keymap.set("n", "<leader>n", function()
	Snacks.notifier.show_history()
end, { desc = "Notification History" })
keymap.set("n", "<leader>qs", function()
	require("persistence").load()
end, { desc = "Restore Session" })
