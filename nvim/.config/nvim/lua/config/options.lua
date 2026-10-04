local opt = vim.opt

-- The interface
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.cursorlineopt = "number"
opt.termguicolors = true
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.conceallevel = 2
opt.showmode = false
opt.laststatus = 3
opt.pumheight = 12
opt.winborder = "single"
opt.fillchars = {
    eob = " ",
    vert = "│",
    horiz = "─",
    fold = " ",
    foldopen = "−",
    foldclose = "+",
}
opt.list = true
opt.listchars = {
    tab = "→ ",
    trail = "·",
    nbsp = "␣",
}

-- Indentation (frontend filetypes use 2, see autocmds; .editorconfig wins)
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.smartindent = true

-- Searching
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true
opt.inccommand = "split"

-- Windows
opt.splitright = true
opt.splitbelow = true

-- Archives
opt.undofile = true
opt.swapfile = false
opt.backup = false
-- Agents edit files outside nvim: reload them when they change on disk
opt.autoread = true

-- Performance
opt.updatetime = 250
opt.timeoutlen = 500

-- Mouse
opt.mouse = "a"

-- Autocomplete
opt.completeopt = {
    "menuone",
    "noselect",
    "popup",
    "fuzzy",
}

-- Colorscheme (colors/yev.lua)
vim.g.yev_transparent = true
opt.background = "dark"
vim.cmd.colorscheme("yev")
