local function augroup(name)
	return vim.api.nvim_create_augroup("user_" .. name, { clear = true })
end

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup("highlight_yank"),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Reload file if changed outside of nvim
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	group = augroup("checktime"),
	callback = function()
		if vim.o.buftype ~= "nofile" then
			vim.cmd("checktime")
		end
	end,
})

-- Jump to last cursor position when reopening a file
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup("last_loc"),
	callback = function(ev)
		local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
		local lcount = vim.api.nvim_buf_line_count(ev.buf)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- Close utility windows with q
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("close_with_q"),
	pattern = { "help", "qf", "man", "checkhealth", "gitsigns-blame", "undotree" },
	callback = function(ev)
		vim.bo[ev.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = ev.buf, silent = true })
	end,
})

-- Diagnostic underlines: undercurl (squiggly), not a flat underline.
-- catppuccin (like most themes) defines DiagnosticUnderline* with `underline`;
-- flip each to `undercurl` while keeping its `sp` colour. On ColorScheme so it
-- survives theme reloads. Terminal support is already end-to-end: ghostty +
-- tmux `usstyle` + tmux-256color `Smulx` all carry undercurl.
vim.api.nvim_create_autocmd("ColorScheme", {
	group = augroup("diagnostic_undercurl"),
	callback = function()
		for _, name in ipairs({
			"DiagnosticUnderlineError",
			"DiagnosticUnderlineWarn",
			"DiagnosticUnderlineInfo",
			"DiagnosticUnderlineHint",
			"DiagnosticUnderlineOk",
		}) do
			local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
			hl.underline = nil
			hl.undercurl = true
			hl.cterm = hl.cterm or {}
			hl.cterm.underline = nil
			hl.cterm.undercurl = true
			vim.api.nvim_set_hl(0, name, hl)
		end
	end,
})

-- Disable concealing in some file formats
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("conceal"),
	pattern = { "json", "jsonc", "markdown" },
	callback = function()
		vim.opt_local.conceallevel = 0
	end,
})
