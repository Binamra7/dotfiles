-- Completion (blink.cmp) ---------------------------------------------------
require("blink.cmp").setup({
	keymap = { preset = "enter" },
	completion = {
		documentation = { auto_show = true },
	},
	signature = { enabled = true },
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},
	fuzzy = { implementation = "prefer_rust_with_warning" },
})

-- Copilot (ghost text) -------------------------------------------------
require("copilot").setup({
	suggestion = {
		auto_trigger = true,
		keymap = {
			accept = "<C-l>",
			accept_word = "<M-l>",
			accept_line = "<M-S-l>",
			next = "<M-]>",
			prev = "<M-[>",
			dismiss = "<C-]>",
		},
	},
	filetypes = {
		markdown = true,
		help = true,
	},
})

-- Formatting (conform) ---------------------------------------------------
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		ruby = { "rubocop" },
		javascript = { "prettier" },
		typescript = { "prettier" },
		javascriptreact = { "prettier" },
		typescriptreact = { "prettier" },
		html = { "prettier" },
		htmlangular = { "prettier" },
		css = { "prettier" },
		scss = { "prettier" },
		json = { "prettier" },
		jsonc = { "prettier" },
		yaml = { "prettier" },
		markdown = { "prettier" },
	},
	formatters = {
		rubocop = {
			-- Only format when the project has a rubocop config
			condition = function(_, ctx)
				return vim.fs.find({ ".rubocop.yml" }, { path = ctx.filename, upward = true })[1]
			end,
			-- rubocop -A (auto-correct all) through the rubocop daemon
			args = { "--server", "--auto-correct-all", "--stderr", "--stdin", "$FILENAME" },
		},
	},
	format_on_save = function(bufnr)
		if vim.g.autoformat == false or vim.b[bufnr].autoformat == false then
			return
		end
		return { timeout_ms = 3000, lsp_format = "fallback" }
	end,
})

-- Auto pairs ---------------------------------------------------------------
require("mini.pairs").setup()

-- Bracket navigation ([b ]b buffers, [q ]q quickfix, [n ]n treesitter, ...)
require("mini.bracketed").setup({
	file = { suffix = "" },
	window = { suffix = "" },
	quickfix = { suffix = "" },
	yank = { suffix = "" },
	treesitter = { suffix = "n" },
})

-- Better increment/decrement (<C-a>/<C-x> in config/keymaps.lua) -------------
local augend = require("dial.augend")
require("dial.config").augends:register_group({
	default = {
		augend.integer.alias.decimal,
		augend.integer.alias.hex,
		augend.date.alias["%Y/%m/%d"],
		augend.constant.alias.bool,
		augend.semver.alias.semver,
		augend.constant.new({ elements = { "let", "const" } }),
	},
})

-- Undotree (<leader>u in config/keymaps.lua) --------------------------------
require("undotree").setup()
