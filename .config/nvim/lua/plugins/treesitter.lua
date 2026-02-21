return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		opts = {
			-- The "Essential" list for Rails & JS development
			ensure_installed = {
				"ruby",
				"erb", -- Essential for Rails templates
				"javascript",
				"typescript", -- Often used alongside JS
				"html",
				"css",
				"json",
				"yaml", -- For database.yml and config files
				"lua", -- For your Nvim config itself
				"markdown",
			},

			-- Enable the core features
			highlight = {
				enable = true,
				-- Setting this to true will run both treesitter and syntax highlighting.
				-- Generally, keeping it false (default) is faster and cleaner.
				additional_vim_regex_highlighting = false,
			},

			indent = {
				enable = true, -- Better indentation based on code structure
			},
			-- High-speed selection
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>", -- Start selecting code blocks
					node_incremental = "<C-space>", -- Expand to the next scope (e.g., from variable to method)
					scope_incremental = false,
					node_decremental = "<bs>", -- Shrink selection (Backspace)
				},
			},
			-- If you use 'windwp/nvim-ts-autotag', you'd enable it here:
			-- autotag = { enable = true },
		},
		config = function(_, opts)
			local TS = require("nvim-treesitter")
			TS.setup(opts)

			-- MDX
			vim.filetype.add({
				extension = {
					mdx = "mdx",
				},
			})
			vim.treesitter.language.register("markdown", "mdx")
		end,
	},
}
