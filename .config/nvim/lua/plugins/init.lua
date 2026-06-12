-- Plugins via Neovim's native package manager (:h vim.pack)
-- Installed to stdpath('data')/site/pack/core/opt. Update with :PackUpdate.

-- Build hooks: run after a plugin is installed or updated
vim.api.nvim_create_autocmd("PackChanged", {
	group = vim.api.nvim_create_augroup("user_pack_build", { clear = true }),
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if kind ~= "install" and kind ~= "update" then
			return
		end
		if name == "telescope-fzf-native.nvim" then
			vim.system({ "make" }, { cwd = ev.data.path })
		elseif name == "nvim-treesitter" and kind == "update" then
			vim.schedule(function()
				require("nvim-treesitter").update()
			end)
		end
	end,
})

local function gh(repo)
	return "https://github.com/" .. repo
end

vim.pack.add({
	-- colorscheme
	{ src = gh("catppuccin/nvim"), name = "catppuccin" },

	-- treesitter (main rewrite branch, required for nvim 0.12 workflows)
	{ src = gh("nvim-treesitter/nvim-treesitter"), version = "main" },
	{ src = gh("windwp/nvim-ts-autotag") },

	-- lsp / tooling
	{ src = gh("neovim/nvim-lspconfig") }, -- used only for its lsp/<server>.lua configs
	{ src = gh("mason-org/mason.nvim") }, -- LSP/tool binary installer
	{ src = gh("stevearc/conform.nvim") },

	-- completion
	{ src = gh("Saghen/blink.cmp"), version = vim.version.range("1.*") }, -- release tag → prebuilt fuzzy lib
	{ src = gh("rafamadriz/friendly-snippets") },
	{ src = gh("zbirenbaum/copilot.lua") },

	-- editor
	{ src = gh("nvim-lua/plenary.nvim") },
	{ src = gh("nvim-telescope/telescope.nvim") },
	{ src = gh("nvim-telescope/telescope-fzf-native.nvim") },
	{ src = gh("nvim-telescope/telescope-file-browser.nvim") },
	{ src = gh("folke/flash.nvim") },
	{ src = gh("stevearc/oil.nvim") },
	{ src = gh("lewis6991/gitsigns.nvim") },
	{ src = gh("folke/persistence.nvim") },
	{ src = gh("brenoprata10/nvim-highlight-colors") },

	-- coding helpers
	{ src = gh("monaqa/dial.nvim") },
	{ src = gh("nvim-mini/mini.bracketed") },
	{ src = gh("nvim-mini/mini.pairs") },
	{ src = gh("jiaoshijie/undotree") },

	-- ui
	{ src = gh("nvim-mini/mini.icons") },
	{ src = gh("folke/snacks.nvim") },
	{ src = gh("nvim-lualine/lualine.nvim") },
	{ src = gh("akinsho/bufferline.nvim") },
	{ src = gh("folke/zen-mode.nvim") },
})

vim.api.nvim_create_user_command("PackUpdate", function()
	vim.pack.update()
end, { desc = "Update all plugins" })

require("plugins.ui")
require("plugins.treesitter")
require("plugins.editor")
require("plugins.coding")
