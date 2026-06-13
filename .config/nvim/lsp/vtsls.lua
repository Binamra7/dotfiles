-- Merged on top of nvim-lspconfig's lsp/vtsls.lua
return {
	settings = {
		typescript = {
			inlayHints = {
				includeInlayParameterNameHints = "literal",
				includeInlayFunctionParameterTypeHints = true,
			},
		},
		vtsls = {
			tsserver = {
				globalPlugins = {
					-- Angular support for inline templates in .ts files
					{
						name = "@angular/language-server",
						location = vim.fn.stdpath("data")
							.. "/mason/packages/angular-language-server/node_modules/@angular/language-server",
						enableForWorkspaceTypeScriptVersions = false,
					},
				},
			},
		},
	},
}
