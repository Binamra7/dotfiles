local keymap = vim.keymap

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
telescope.load_extension("file_browser")

local builtin = require("telescope.builtin")
keymap.set("n", ";f", function()
	builtin.find_files({ hidden = true })
end, { desc = "Find Files" })
keymap.set("n", ";r", function()
	builtin.live_grep({ additional_args = { "--hidden" } })
end, { desc = "Live Grep" })
keymap.set("n", "\\\\", builtin.buffers, { desc = "Buffers" })
keymap.set("n", ";t", builtin.help_tags, { desc = "Help Tags" })
keymap.set("n", ";;", builtin.resume, { desc = "Resume Last Picker" })
keymap.set("n", ";e", builtin.diagnostics, { desc = "Diagnostics" })
keymap.set("n", ";s", builtin.treesitter, { desc = "Treesitter Symbols" })
keymap.set("n", ";c", builtin.lsp_incoming_calls, { desc = "LSP Incoming Calls" })
keymap.set("n", "<leader>fP", function()
	builtin.find_files({ cwd = vim.fn.stdpath("data") .. "/site/pack/core/opt" })
end, { desc = "Find Plugin File" })
keymap.set("n", "sf", function()
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

-- Flash (f = jump, S = treesitter select; native s stays untouched) -------
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
keymap.set({ "n", "x", "o" }, "f", function()
	require("flash").jump()
end, { desc = "Flash" })
keymap.set({ "n", "x", "o" }, "S", function()
	require("flash").treesitter()
end, { desc = "Flash Treesitter" })

-- Oil ----------------------------------------------------------------------
require("oil").setup({
	default_file_explorer = false,
	columns = { "icon" },
	keymaps = {
		["<C-h>"] = false, -- avoid conflict with window navigation
		["<M-h>"] = "actions.select_split",
	},
	view_options = { show_hidden = true },
})
keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory in Oil" })

-- Gitsigns -------------------------------------------------------------
require("gitsigns").setup({
	on_attach = function(buffer)
		local gs = require("gitsigns")
		local function map(mode, l, r, desc)
			keymap.set(mode, l, r, { buffer = buffer, desc = desc })
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

-- Sessions -------------------------------------------------------------
require("persistence").setup()

-- Color previews (hex / tailwind classes) -------------------------------
require("nvim-highlight-colors").setup({
	render = "background",
	enable_hex = true,
	enable_tailwind = true,
})
