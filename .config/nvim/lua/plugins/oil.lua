return {
	{
		"stevearc/oil.nvim",
		opts = {
			default_file_explorer = false, -- Important!
			columns = { "icon" },
			keymaps = {
				["<C-h>"] = false, -- Disable to avoid conflict with window navigation
				["<M-h>"] = "actions.select_split",
			},
			view_options = {
				show_hidden = true,
			},
		},
		-- Optional: define a keymap to open Oil
		keys = {
			{ "-", "<CMD>Oil<CR>", desc = "Open parent directory in Oil" },
		},
	},
}
