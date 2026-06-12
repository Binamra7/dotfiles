-- Colorscheme
require("catppuccin").setup({
	flavour = "mocha",
	transparent_background = true,
})
vim.cmd.colorscheme("catppuccin")

-- Noice: floating cmdline popup + message routing.
-- Native ui2 was tried first, but with cmdheight=0 it temporarily sets
-- cmdheight=1 while typing a command (hardcoded), shifting the buffer;
-- cmdheight=1 wastes a row. Noice's ext_cmdline popup needs neither.
require("noice").setup({
	cmdline = { view = "cmdline_popup" },
	notify = { enabled = true }, -- routes through vim.notify → snacks notifier
	lsp = {
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
		},
	},
	presets = {
		bottom_search = true,
		lsp_doc_border = true,
	},
	routes = {
		{
			filter = { event = "notify", find = "No information available" },
			opts = { skip = true },
		},
	},
})

-- Icons (also mocks nvim-web-devicons for telescope/lualine/oil)
require("mini.icons").setup()
MiniIcons.mock_nvim_web_devicons()

-- Snacks: notifier, dashboard, smooth scroll, lazygit, git browse
require("snacks").setup({
	bigfile = { enabled = true },
	notifier = { enabled = true, timeout = 3000 },
	dashboard = { enabled = true },
	scroll = { enabled = true },
	lazygit = {},
	gitbrowse = {},
})

-- Statusline
local function macro_recording()
	local reg = vim.fn.reg_recording()
	return reg ~= "" and ("recording @" .. reg) or ""
end

-- statusline doesn't redraw on its own when recording starts/stops
vim.api.nvim_create_autocmd("RecordingEnter", {
	group = vim.api.nvim_create_augroup("user_macro_status", { clear = true }),
	callback = function()
		require("lualine").refresh()
	end,
})
vim.api.nvim_create_autocmd("RecordingLeave", {
	group = "user_macro_status",
	callback = function()
		-- reg_recording() is still set during the event; refresh just after
		vim.defer_fn(function()
			require("lualine").refresh()
		end, 50)
	end,
})

require("lualine").setup({
	options = {
		theme = "auto", -- derives from the active colorscheme
		globalstatus = true,
		disabled_filetypes = { statusline = { "snacks_dashboard" } },
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch" },
		lualine_c = {
			"diagnostics",
			{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
			{ "filename", path = 1, symbols = { modified = " ●", readonly = " 󰌾" } },
		},
		lualine_x = {
			{ macro_recording, color = { fg = "#f38ba8", gui = "bold" } },
			"diff",
		},
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
})

-- Buffer bar
require("bufferline").setup({
	options = {
		mode = "buffers",
		show_buffer_close_icons = false,
		show_close_icon = false,
		separator_style = "thin",
		always_show_bufferline = false, -- only show with 2+ buffers
	},
})

-- Which-key: popup with available keybindings after pressing a prefix
require("which-key").setup({
	preset = "helix", -- same look LazyVim used
	spec = {
		{ "<leader>b", group = "buffer" },
		{ "<leader>c", group = "code" },
		{ "<leader>f", group = "file/find" },
		{ "<leader>g", group = "git" },
		{ "<leader>gh", group = "hunks" },
		{ "<leader>q", group = "quit/session" },
		{ "<leader>t", group = "toggle/buffers" },
		{ "[", group = "prev" },
		{ "]", group = "next" },
		{ "g", group = "goto" },
		{ "s", group = "windows/browser" },
	},
})

-- Zen mode
require("zen-mode").setup({
	plugins = {
		gitsigns = true,
		tmux = { enabled = true },
	},
})
vim.keymap.set("n", "<leader>z", "<cmd>ZenMode<cr>", { desc = "Zen Mode" })
