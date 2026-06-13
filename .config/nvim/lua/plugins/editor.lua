-- Telescope ---------------------------------------------------------------
local telescope = require("telescope")
telescope.setup({
	defaults = {
		layout_strategy = "horizontal",
		layout_config = {
			prompt_position = "top",
			horizontal = { preview_width = 0.5 },
		},
		sorting_strategy = "ascending", -- best match at top
		wrap_results = false,
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
pcall(telescope.load_extension, "file_browser")

-- Flash (mapped to f / S in config/keymaps.lua; native s stays untouched) ----
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

-- Oil ------------------------------------------------------------------------
require("oil").setup({
	default_file_explorer = false,
	columns = { "icon" },
	keymaps = {
		["<C-h>"] = false, -- avoid conflict with window navigation
		["<M-h>"] = "actions.select_split",
	},
	view_options = { show_hidden = true },
})

-- Gitsigns -----------------------------------------------------------------
require("gitsigns").setup({
	on_attach = function(buffer)
		local gs = require("gitsigns")
		local function map(mode, l, r, desc)
			vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
		end
		map("n", "]h", function()
			gs.nav_hunk("next")
		end, "Next Hunk")
		map("n", "[h", function()
			gs.nav_hunk("prev")
		end, "Prev Hunk")
		map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
		map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
		map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
	end,
})

-- Diffview: proper diff UI (:DiffviewOpen) and file history -------------------
require("diffview").setup({
	keymaps = {
		view = { { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } } },
		file_panel = { { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } } },
		file_history_panel = { { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } } },
	},
})

-- Sessions ---------------------------------------------------------------
require("persistence").setup()

-- Highlight TODO/FIXME/HACK/NOTE in comments (]t/[t + ;d in keymaps) ------
require("todo-comments").setup()

-- Color previews (hex / tailwind classes) ----------------------------------
require("nvim-highlight-colors").setup({
	render = "background",
	enable_hex = true,
	enable_tailwind = true,
})
