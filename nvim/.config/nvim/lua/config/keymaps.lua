-- General keymaps. Plugin keymaps live next to each plugin (lua/plugins/*).
local function map(mode, keys, action, description)
    vim.keymap.set(mode, keys, action, { silent = true, desc = description })
end

map("n", "<Esc>", "<cmd>nohlsearch<CR>", "Clear search highlight")
map("n", "<leader>w", "<cmd>write<CR>", "Save file")
map("n", "<leader>q", "<cmd>quit<CR>", "Close window")

-- Windows (also from a terminal: agents, dev server...)
for key, direction in pairs({ h = "Left", j = "Bottom", k = "Top", l = "Right" }) do
    map("n", "<C-" .. key .. ">", "<C-w>" .. key, direction .. " window")
    map("t", "<C-" .. key .. ">", "<C-\\><C-n><C-w>" .. key, direction .. " window")
end
map("t", "<Esc><Esc>", "<C-\\><C-n>", "Exit terminal mode")

-- Buffers
map("n", "<S-h>", "<cmd>bprevious<CR>", "Previous buffer")
map("n", "<S-l>", "<cmd>bnext<CR>", "Next buffer")

-- Keep the selection when indenting, move selected lines
map("v", "<", "<gv", "Indent left")
map("v", ">", ">gv", "Indent right")
map("v", "J", ":move '>+1<CR>gv=gv", "Move lines down")
map("v", "K", ":move '<-2<CR>gv=gv", "Move lines up")

-- Keep the cursor centered when jumping
map("n", "<C-d>", "<C-d>zz", "Half page down")
map("n", "<C-u>", "<C-u>zz", "Half page up")
map("n", "n", "nzzzv", "Next match")
map("n", "N", "Nzzzv", "Previous match")

-- UI
map("n", "<leader>ub", function()
    vim.o.background = vim.o.background == "dark" and "light" or "dark"
end, "Toggle light/dark")
map("n", "<leader>ut", function()
    vim.g.transparent = not vim.g.transparent
    vim.cmd.colorscheme("jetbrains")
end, "Toggle transparency")

-- Agents: references and diagnostics to paste into any agent
local agents = require("config.agents")
map({ "n", "v" }, "<leader>ay", agents.copy_reference, "Copy @file#Lx-y reference")
map("n", "<leader>ax", agents.copy_diagnostics, "Copy diagnostics")

-- Tasks
local tasks = require("config.tasks")
local command = vim.api.nvim_create_user_command
command("Build", tasks.build, { desc = "Compile project" })
command("Run", tasks.run, { desc = "Execute project" })
command("Test", tasks.test, { desc = "Execute tests" })
command("Lint", tasks.lint, { desc = "Lint project" })
command("Task", function(options)
    tasks.task(options.args)
end, { nargs = "+", desc = "Execute command in root of the project" })

map("n", "<leader>tb", tasks.build, "Build project")
map("n", "<leader>tr", tasks.run, "Run project / dev server")
map("n", "<leader>tt", tasks.test, "Run tests")
map("n", "<leader>tl", tasks.lint, "Lint project")
