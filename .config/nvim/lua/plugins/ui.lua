return {
	-- Noice: Messages, Cmdline, and Popupmenu
	{
		"folke/noice.nvim",
		opts = function(_, opts)
			table.insert(opts.routes, {
				filter = {
					event = "notify",
					find = "No information available",
				},
				opts = { skip = true },
			})
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
			table.insert(opts.routes, 1, {
				filter = {
					cond = function()
						return not focused
					end,
				},
				view = "snacks",
				opts = { stop = false },
			})

			opts.commands = {
				all = {
					-- options for the message history that you get with `:Noice`
					view = "split",
					opts = { enter = true, format = "details" },
					filter = {},
				},
			}

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "markdown",
				callback = function(event)
					vim.schedule(function()
						require("noice.text.markdown").keys(event.buf)
					end)
				end,
			})

			opts.presets.lsp_doc_border = true
		end,
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
			scroll = {
				enabled = true,
			},
			explorer = { replace_netrw = false },
			notifier = {
				enabled = true,
				timeout = 3000,
			},
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
