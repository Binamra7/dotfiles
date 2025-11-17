return {
	{
		"craftzdog/solarized-osaka.nvim",
		priority = 1000,
		opts = function()
			return {
				transparent = true,
				styles = {
					comments = { italic = true },
					keywords = { italic = true },
					functions = { italic = true },
					variables = { italic = false },
					sidebars = "transparent",
					floats = "transparent",
				},
			}
		end,
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = function()
			return {
				style = "storm",
				transparent = true,
				styles = {
					sidebars = "transparent",
					floats = "transparent",
				},
			}
		end,
	},
}
