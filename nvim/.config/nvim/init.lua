vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.options")
require("config.autocmds")
require("config.statusline")
require("config.keymaps")
require("config.lazy")
-- After lazy: server configs from nvim-lspconfig must be on the runtimepath
require("config.lsp")
