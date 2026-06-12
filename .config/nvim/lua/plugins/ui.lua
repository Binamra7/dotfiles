-- Colorscheme
require("catppuccin").setup({
	flavour = "mocha",
	transparent_background = true,
})
vim.cmd.colorscheme("catppuccin")

-- Native messages/cmdline UI, "ui2" (replaces noice.nvim): floating
-- cmdline/messages, no press-enter prompts, g< opens the message pager.
-- Experimental but core; see :h ui2.
local ui2_ok, ui2_err = pcall(function()
	require("vim._core.ui2").enable()
end)
if not ui2_ok then
	vim.schedule(function()
		vim.notify("ui2 unavailable: " .. tostring(ui2_err), vim.log.levels.WARN)
	end)
end

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
		lualine_x = { "diff" },
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
