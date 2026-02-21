return {
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				ruby = { "rubocop" },
			},
			formatters = {
				rubocop = {
					-- This tells RuboCop to look for the config file in your project root
					condition = function(self, ctx)
						return vim.fs.find({ ".rubocop.yml" }, { path = ctx.filename, upward = true })[1]
					end,
					-- This runs rubocop -A (auto-correct all) on save
					args = { "--server", "--auto-correct-all", "--stderr", "--stdin", "$FILENAME" },
				},
			},
		},
	},
}
