return {
	-- Noice: Messages, Cmdline, and Popupmenu
	{
		"folke/noice.nvim",
		opts = function(_, opts)
			-- Skip "No information available" notifications
			table.insert(opts.routes, {
				filter = { event = "notify", find = "No information available" },
				opts = { skip = true },
			})

			-- Focus tracking for system notifications (notify-send)
			local focused = true
			vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
				callback = function()
					focused = true
				end,
			})
			vim.api.nvim_create_autocmd({ "FocusLost", "TermOpen" }, {
				callback = function()
					focused = false
				end,
			})

			table.insert(opts.routes, 1, {
				filter = {
					cond = function()
						return not focused
					end,
				},
				view = "notify_send",
				opts = { stop = false },
			})

			opts.commands = {
				all = {
					view = "split",
					opts = { enter = true, format = "details" },
					filter = {},
				},
			}

			opts.presets = opts.presets or {}
			opts.presets.lsp_doc_border = true
		end,
	},

	{
		"rcarriga/nvim-notify",
		opts = { timeout = 3000 }, -- Slights shorter timeout for less clutter
	},

	-- Bufferline: Tabs/Buffers bar
	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		keys = {
			{ "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next Buffer" },
			{ "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev Buffer" },
		},
		opts = {
			options = {
				mode = "buffers", -- Changed from "tabs" to "buffers" to see open files
				show_buffer_close_icons = false,
				show_close_icon = false,
				separator_style = "thin", -- Clean look
				always_show_bufferline = false, -- Only show if more than 1 buffer
			},
		},
	},

	-- Lualine: Statusline
	{
		"nvim-lualine/lualine.nvim",
		opts = function(_, opts)
			local LazyVim = require("lazyvim.util")
			-- Better way to replace the path component
			opts.sections.lualine_c[4] = LazyVim.lualine.pretty_path({
				length = 0,
				relative = "cwd",
				modified_hl = "MatchParen",
				filename_hl = "Bold",
				readonly_icon = " 󰌾 ",
			})
		end,
	},

	-- Snacks: Dashboard and Scroll
	{
		"folke/snacks.nvim",
		opts = {
			scroll = { enabled = false },
		},
	},

	{
		"folke/zen-mode.nvim",
		cmd = "ZenMode",
		opts = {
			plugins = {
				gitsigns = true,
				tmux = { enabled = true },
			},
		},
		keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
	},
}
