local opt = vim.opt

-- Interface
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.termguicolors = true
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.conceallevel = 2
opt.showmode = false
opt.laststatus = 3
opt.cmdheight = 0
opt.pumheight = 12
opt.pumblend = 0
opt.winborder = "rounded"
opt.smoothscroll = true
opt.splitkeep = "screen"
opt.shortmess:append({ I = true, c = true, W = true })
opt.fillchars = {
    eob = " ",
    vert = "│",
    horiz = "─",
    fold = " ",
    foldopen = "\u{f078}",
    foldclose = "\u{f054}",
    foldsep = " ",
    diff = "╱",
}
opt.list = true
opt.listchars = {
    tab = "→ ",
    trail = "·",
    nbsp = "␣",
}

-- Folds by treesitter, all open by default
opt.foldlevel = 99
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldtext = ""

-- Indentation (frontend filetypes use 2, see autocmds; .editorconfig wins)
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.inccommand = "split"

-- Windows
opt.splitright = true
opt.splitbelow = true

-- Files
opt.undofile = true
opt.swapfile = false
opt.backup = false
-- Agents edit files outside nvim: reload them when they change on disk
opt.autoread = true

-- Performance
opt.updatetime = 250
opt.timeoutlen = 400

-- Mouse and clipboard
opt.mouse = "a"
opt.clipboard = "unnamedplus"

-- Completion menu (blink.cmp draws insert completion; this is for cmdline)
opt.completeopt = { "menuone", "noselect", "popup", "fuzzy" }

-- Colorscheme (colors/yev.lua)
vim.g.yev_transparent = true
opt.background = "dark"
vim.cmd.colorscheme("yev")
