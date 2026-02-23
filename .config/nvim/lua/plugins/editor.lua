return {
	{
		enabled = true,
		"folke/flash.nvim",
		-- @type Flash.Config
		opts = {
			modes = {
				char = {
					enabled = false,
				},
				search = {
					forward = true,
					multi_window = false,
					wrap = false,
					incremental = true,
				},
			},
		},
		keys = {
			-- 1. Map 'f' to the Flash Search (usually on 's')
			{
				"f",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Flash",
			},

			-- 2. Map 'S' to the Flash Treesitter Search
			{
				"S",
				mode = { "n", "x", "o" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash Treesitter",
			},

			-- 3. UNBIND the default 's' so you get the native 's' back
			{ "s", mode = { "n", "x", "o" }, false },
		},
	},

	-- Color Previews
	{
		"brenoprata10/nvim-highlight-colors",
		event = "BufReadPre",
		opts = {
			render = "background",
			enable_hex = true,
			enable_tailwind = true,
		},
	},

	{
		"dinhhuy258/git.nvim",
		event = "BufReadPre",
		opts = {
			keymaps = {
				blame = "<Leader>gb",
				browse = "<Leader>go",
			},
		},
	},

	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"nvim-telescope/telescope-file-browser.nvim",
		},
		-- Use opts to define settings so LazyVim merges them properly
		opts = {
			defaults = {
				layout_strategy = "horizontal",
				layout_config = {
					prompt_position = "top", -- Moves search bar to top
					horizontal = {
						preview_width = 0.5,
					},
				},
				sorting_strategy = "ascending", -- Puts best match at top
				wrap_results = false,
				winblend = 0,
				mappings = {
					n = {},
				},
			},
			pickers = {
				diagnostics = {
					theme = "default",
					initial_mode = "normal",
					layout_config = { preview_cutoff = 9999 },
				},
			},
			extensions = {
				file_browser = {
					theme = "dropdown",
					hijack_netrw = true,
				},
			},
		},
		keys = {
			{
				"<leader>fP",
				function()
					require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root })
				end,
				desc = "Find Plugin File",
			},
			{
				";f",
				function()
					require("telescope.builtin").find_files({ hidden = true })
				end,
				desc = "Find Files (Root)",
			},
			{
				";r",
				function()
					require("telescope.builtin").live_grep({ additional_args = { "--hidden" } })
				end,
				desc = "Live Grep",
			},
			{
				"\\\\",
				function()
					require("telescope.builtin").buffers()
				end,
				desc = "Buffers",
			},
			{
				";t",
				function()
					require("telescope.builtin").help_tags()
				end,
				desc = "Help Tags",
			},
			{
				";;",
				function()
					require("telescope.builtin").resume()
				end,
				desc = "Resume Last Picker",
			},
			{
				";e",
				function()
					require("telescope.builtin").diagnostics()
				end,
				desc = "Diagnostics",
			},
			{
				";s",
				function()
					require("telescope.builtin").treesitter()
				end,
				desc = "Treesitter Symbols",
			},
			{
				";c",
				function()
					require("telescope.builtin").lsp_incoming_calls()
				end,
				desc = "LSP Incoming Calls",
			},
			{
				"sf",
				function()
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
				end,
				desc = "Open File Browser",
			},
		},
		config = function(_, opts)
			local telescope = require("telescope")
			telescope.setup(opts)
			telescope.load_extension("fzf")
			telescope.load_extension("file_browser")
		end,
	},

	{
		"kazhala/close-buffers.nvim",
		event = "VeryLazy",
		keys = {
			{
				"<leader>th",
				function()
					require("close_buffers").delete({ type = "hidden" })
				end,
				desc = "Close Hidden Buffers",
			},
			{
				"<leader>tu",
				function()
					require("close_buffers").delete({ type = "nameless" })
				end,
				desc = "Close Nameless Buffers",
			},
		},
	},

	{
		"saghen/blink.cmp",
		opts = {
			completion = {
				menu = { winblend = vim.o.pumblend },
			},
			signature = {
				window = { winblend = vim.o.pumblend },
			},
		},
	},
}
