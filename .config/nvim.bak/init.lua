if vim.loader then
	vim.loader.enable()
end

vim.cmd([[
  highlight NeoTreeNormal guibg=NONE
  highlight NeoTreeNormalNC guibg=NONE
  highlight NeoTreeEndOfBuffer guibg=NONE
]])

require("config.lazy")
