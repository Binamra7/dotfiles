return {
	-- 1. Tools Management (Mason)
	{
		"mason-org/mason.nvim",
		opts = function(_, opts)
			-- Ensure the table exists so we don't get a Lua error
			opts.ensure_installed = opts.ensure_installed or {}

			-- Add your specific tools
			vim.list_extend(opts.ensure_installed, {
				"solargraph",
				"rubocop",
				"vtsls",
				"css-lsp", -- Corrected name
				"tailwindcss-language-server",
				"yaml-language-server",
				"lua-language-server",
				"stylua",
			})
		end,
	},

	-- 2. LSP Servers & Keymaps (Merged into one block)
	{
		"neovim/nvim-lspconfig",
		opts = {
			inlay_hints = { enabled = true },
			-- DECOMPRESSED KEYS: This is the correct way to add keys to LazyVim
			keys = {
				{
					"gd",
					function()
						require("telescope.builtin").lsp_definitions({ reuse_win = false })
					end,
					desc = "Goto Definition",
				},
			},
			servers = {
				-- RUBY / RAILS
				solargraph = {
					root_dir = function(...)
						return require("lspconfig.util").root_pattern("Gemfile", ".git", ".")(...)
					end,
					settings = {
						solargraph = {
							diagnostics = true,
							useBundler = true,
							formatting = false,
						},
					},
				},
				-- JAVASCRIPT & TYPESCRIPT
				vtsls = {
					settings = {
						typescript = {
							inlayHints = {
								includeInlayParameterNameHints = "literal",
								includeInlayFunctionParameterTypeHints = true,
							},
						},
					},
				},
				cssls = {},
				tailwindcss = {},
				yamlls = {
					settings = {
						yaml = {
							keyOrdering = false,
						},
					},
				},
				lua_ls = {
					settings = {
						Lua = {
							diagnostics = { globals = { "vim" } },
						},
					},
				},
			},
		},
	},
}
