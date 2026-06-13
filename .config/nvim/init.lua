vim.loader.enable()

-- Leaders must be set before any keymaps/plugins
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("plugins") -- vim.pack + plugin setup
require("config.lsp") -- native LSP: servers, diagnostics, attach keymaps
