local gh = function(repo)
	return "https://github.com/" .. repo
end

local specs = {
	gh("catppuccin/nvim"),
	gh("folke/flash.nvim"),
	gh("brenoprata10/nvim-highlight-colors"),
	gh("dinhhuy258/git.nvim"),
	gh("nvim-lua/plenary.nvim"),
	gh("nvim-tree/nvim-web-devicons"),
	gh("nvim-telescope/telescope.nvim"),
	gh("nvim-telescope/telescope-fzf-native.nvim"),
	gh("nvim-telescope/telescope-file-browser.nvim"),
	gh("kazhala/close-buffers.nvim"),
	gh("saghen/blink.cmp"),
	gh("stevearc/oil.nvim"),
	gh("MunifTanjim/nui.nvim"),
	gh("rcarriga/nvim-notify"),
	gh("folke/noice.nvim"),
	gh("akinsho/bufferline.nvim"),
	gh("nvim-lualine/lualine.nvim"),
	gh("folke/snacks.nvim"),
	gh("folke/zen-mode.nvim"),
	gh("stevearc/conform.nvim"),
	gh("smjonas/inc-rename.nvim"),
	gh("nvim-mini/mini.bracketed"),
	gh("monaqa/dial.nvim"),
	gh("zbirenbaum/copilot.lua"),
	gh("jiaoshijie/undotree"),
	gh("mason-org/mason.nvim"),
	gh("williamboman/mason-lspconfig.nvim"),
	gh("WhoIsSethDaniel/mason-tool-installer.nvim"),
	gh("neovim/nvim-lspconfig"),
	gh("nvim-treesitter/nvim-treesitter"),
}

vim.pack.add(specs, {
	confirm = false,
	load = true,
})

for _, name in ipairs({
	"nvim",
	"flash.nvim",
	"nvim-highlight-colors",
	"git.nvim",
	"plenary.nvim",
	"nvim-web-devicons",
	"telescope.nvim",
	"telescope-fzf-native.nvim",
	"telescope-file-browser.nvim",
	"close-buffers.nvim",
	"blink.cmp",
	"oil.nvim",
	"nui.nvim",
	"nvim-notify",
	"noice.nvim",
	"bufferline.nvim",
	"lualine.nvim",
	"snacks.nvim",
	"zen-mode.nvim",
	"conform.nvim",
	"inc-rename.nvim",
	"mini.bracketed",
	"dial.nvim",
	"copilot.lua",
	"undotree",
	"mason.nvim",
	"mason-lspconfig.nvim",
	"mason-tool-installer.nvim",
	"nvim-lspconfig",
	"nvim-treesitter",
}) do
	vim.cmd.packadd(name)
end

require("catppuccin").setup({
	flavour = "mocha",
	transparent_background = true,
})
vim.cmd.colorscheme("catppuccin")

require("flash").setup({
	modes = {
		char = { enabled = false },
		search = {
			forward = true,
			multi_window = false,
			wrap = false,
			incremental = true,
		},
	},
})

vim.keymap.set({ "n", "x", "o" }, "f", function()
	require("flash").jump()
end, { desc = "Flash" })
vim.keymap.set({ "n", "x", "o" }, "S", function()
	require("flash").treesitter()
end, { desc = "Flash Treesitter" })

require("nvim-highlight-colors").setup({
	render = "background",
	enable_hex = true,
	enable_tailwind = true,
})

require("git").setup({
	keymaps = {
		blame = "<Leader>gb",
		browse = "<Leader>go",
	},
})

local telescope = require("telescope")
telescope.setup({
	defaults = {
		layout_strategy = "horizontal",
		layout_config = {
			prompt_position = "top",
			horizontal = {
				preview_width = 0.5,
			},
		},
		sorting_strategy = "ascending",
		wrap_results = false,
		winblend = 0,
		mappings = { n = {} },
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
})
pcall(telescope.load_extension, "fzf")
telescope.load_extension("file_browser")

local builtin = require("telescope.builtin")
local plugin_root = vim.fn.stdpath("data") .. "/site/pack/core/opt"
vim.keymap.set("n", "<leader>fP", function()
	builtin.find_files({ cwd = plugin_root })
end, { desc = "Find Plugin File" })
vim.keymap.set("n", ";f", function()
	builtin.find_files({ hidden = true })
end, { desc = "Find Files (Root)" })
vim.keymap.set("n", ";r", function()
	builtin.live_grep({ additional_args = { "--hidden" } })
end, { desc = "Live Grep" })
vim.keymap.set("n", "\\\\", function()
	builtin.buffers()
end, { desc = "Buffers" })
vim.keymap.set("n", ";t", function()
	builtin.help_tags()
end, { desc = "Help Tags" })
vim.keymap.set("n", ";;", function()
	builtin.resume()
end, { desc = "Resume Last Picker" })
vim.keymap.set("n", ";e", function()
	builtin.diagnostics()
end, { desc = "Diagnostics" })
vim.keymap.set("n", ";s", function()
	builtin.treesitter()
end, { desc = "Treesitter Symbols" })
vim.keymap.set("n", ";c", function()
	builtin.lsp_incoming_calls()
end, { desc = "LSP Incoming Calls" })
vim.keymap.set("n", "sf", function()
	telescope.extensions.file_browser.file_browser({
		path = "%:p:h",
		cwd = vim.fn.expand("%:p:h"),
		respect_gitignore = false,
		hidden = true,
		grouped = true,
		previewer = false,
		initial_mode = "normal",
		layout_config = { height = 40, prompt_position = "top" },
	})
end, { desc = "Open File Browser" })

vim.keymap.set("n", "<leader>th", function()
	require("close_buffers").delete({ type = "hidden" })
end, { desc = "Close Hidden Buffers" })
vim.keymap.set("n", "<leader>tu", function()
	require("close_buffers").delete({ type = "nameless" })
end, { desc = "Close Nameless Buffers" })

require("blink.cmp").setup({
	completion = {
		menu = { winblend = vim.o.pumblend },
	},
	signature = {
		window = { winblend = vim.o.pumblend },
	},
})

require("oil").setup({
	default_file_explorer = false,
	columns = { "icon" },
	keymaps = {
		["<C-h>"] = false,
		["<M-h>"] = "actions.select_split",
	},
	view_options = {
		show_hidden = true,
	},
})
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory in Oil" })

local focused = true
vim.api.nvim_create_autocmd("FocusGained", {
	callback = function()
		focused = true
	end,
})
vim.api.nvim_create_autocmd("FocusLost", {
	callback = function()
		focused = false
	end,
})

require("noice").setup({
	routes = {
		{
			filter = {
				cond = function()
					return not focused
				end,
			},
			view = "snacks",
			opts = { stop = false },
		},
		{
			filter = {
				event = "notify",
				find = "No information available",
			},
			opts = { skip = true },
		},
	},
	commands = {
		all = {
			view = "split",
			opts = { enter = true, format = "details" },
			filter = {},
		},
	},
	presets = {
		lsp_doc_border = true,
	},
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function(event)
		vim.schedule(function()
			require("noice.text.markdown").keys(event.buf)
		end)
	end,
})

require("bufferline").setup({
	options = {
		mode = "buffers",
		show_buffer_close_icons = false,
		show_close_icon = false,
		separator_style = "thin",
		always_show_bufferline = false,
	},
})
vim.keymap.set("n", "<Tab>", "<Cmd>BufferLineCycleNext<CR>", { desc = "Next Buffer" })
vim.keymap.set("n", "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Prev Buffer" })

require("lualine").setup({
	options = {
		theme = "auto",
	},
	sections = {
		lualine_c = {
			{
				"filename",
				path = 1,
				newfile_status = true,
			},
		},
	},
})

require("snacks").setup({
	scroll = { enabled = true },
	explorer = { replace_netrw = false },
	notifier = { enabled = true, timeout = 3000 },
})

require("zen-mode").setup({
	plugins = {
		gitsigns = true,
		tmux = { enabled = true },
	},
})
vim.keymap.set("n", "<leader>z", "<cmd>ZenMode<cr>", { desc = "Zen Mode" })

require("conform").setup({
	formatters_by_ft = {
		ruby = { "rubocop" },
	},
	formatters = {
		rubocop = {
			condition = function(_, ctx)
				return vim.fs.find({ ".rubocop.yml" }, { path = ctx.filename, upward = true })[1]
			end,
			args = { "--server", "--auto-correct-all", "--stderr", "--stdin", "$FILENAME" },
		},
	},
})

require("inc_rename").setup()

require("mini.bracketed").setup({
	file = { suffix = "" },
	window = { suffix = "" },
	quickfix = { suffix = "" },
	yank = { suffix = "" },
	treesitter = { suffix = "n" },
})

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

vim.keymap.set("n", "<C-a>", function()
	return require("dial.map").inc_normal()
end, { expr = true, desc = "Increment" })
vim.keymap.set("n", "<C-x>", function()
	return require("dial.map").dec_normal()
end, { expr = true, desc = "Decrement" })

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

require("undotree").setup({})
vim.keymap.set("n", "<leader>u", "<cmd>lua require('undotree').toggle()<cr>", { desc = "Undo Tree" })

require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = {
		"solargraph",
		"vtsls",
		"cssls",
		"tailwindcss",
		"yamlls",
		"lua_ls",
	},
})
require("mason-tool-installer").setup({
	ensure_installed = {
		"solargraph",
		"rubocop",
		"vtsls",
		"css-lsp",
		"tailwindcss-language-server",
		"yaml-language-server",
		"lua-language-server",
		"stylua",
	},
})

local on_attach = function(client, bufnr)
	if client.server_capabilities.inlayHintProvider then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end

	vim.keymap.set("n", "gd", function()
		require("telescope.builtin").lsp_definitions({ reuse_win = false })
	end, { buffer = bufnr, desc = "Goto Definition" })
end

local lspconfig = require("lspconfig")
local servers = {
	solargraph = {},
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
}

for server, config in pairs(servers) do
	config.on_attach = on_attach
	lspconfig[server].setup(config)
end

require("nvim-treesitter").setup({
	ensure_installed = {
		"angular",
		"ruby",
		"erb",
		"javascript",
		"typescript",
		"html",
		"css",
		"json",
		"yaml",
		"lua",
		"markdown",
	},
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	indent = {
		enable = true,
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<C-space>",
			node_incremental = "<C-space>",
			scope_incremental = false,
			node_decremental = "<bs>",
		},
	},
})

vim.filetype.add({
	extension = {
		mdx = "mdx",
	},
})
vim.treesitter.language.register("markdown", "mdx")
