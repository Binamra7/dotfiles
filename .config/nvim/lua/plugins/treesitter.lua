local TS = require("nvim-treesitter")

TS.setup({})

-- Parsers beyond the bundled ones (c, lua, vim, vimdoc, query, markdown are built in)
local ensure_installed = {
	"angular",
	"bash",
	"css",
	"diff",
	"embedded_template", -- ERB
	"html",
	"javascript",
	"jsdoc",
	"json",
	"lua",
	"luadoc",
	"markdown",
	"markdown_inline",
	"query",
	"regex",
	"ruby",
	"scss",
	"toml",
	"tsx",
	"typescript",
	"vim",
	"vimdoc",
	"yaml",
}
TS.install(ensure_installed) -- async, skips already-installed parsers

-- Enable highlighting + indentation whenever a parser exists for the filetype
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
	callback = function(ev)
		local lang = vim.treesitter.language.get_lang(ev.match)
		if lang and vim.treesitter.language.add(lang) then
			vim.treesitter.start(ev.buf, lang)
			vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end
	end,
})

-- Angular templates
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
	group = vim.api.nvim_create_augroup("user_angular_template", { clear = true }),
	pattern = { "*.component.html", "*.container.html" },
	callback = function()
		pcall(vim.treesitter.start, 0, "angular")
	end,
})

-- Auto close/rename HTML tags (html, erb, angular, jsx)
require("nvim-ts-autotag").setup({})
