local map = vim.keymap.set

local default_options = { silent = true }

map("n", "<Esc>", "<cmd>nohlsearch<CR>", default_options)

map("n", "<leader>w", "<cmd>write<CR>", { silent = true, desc = "Save file" })
map("n", "<leader>q", "<cmd>quit<CR>", { silent = true, desc = "Exit window" })

-- Navigation between windows
map("n", "<C-h>", "<C-w>h", { silent = true, desc = "Left window" })
map("n", "<C-j>", "<C-w>j", { silent = true, desc = "Bottom window" })
map("n", "<C-k>", "<C-w>k", { silent = true, desc = "Top window" })
map("n", "<C-l>", "<C-w>l", { silent = true, desc = "Right window" })

-- Same navigation from a terminal (agents, lazygit, dev server)
map("t", "<C-h>", "<C-\\><C-n><C-w>h", { silent = true, desc = "Left window" })
map("t", "<C-j>", "<C-\\><C-n><C-w>j", { silent = true, desc = "Bottom window" })
map("t", "<C-k>", "<C-\\><C-n><C-w>k", { silent = true, desc = "Top window" })
map("t", "<C-l>", "<C-\\><C-n><C-w>l", { silent = true, desc = "Right window" })

-- Maintain selection on indentation
map("v", "<", "<gv", default_options)
map("v", ">", ">gv", default_options)

-- Move selected lines
map("v", "J", ":move '>+1<CR>gv=gv", default_options)
map("v", "K", ":move '<-2<CR>gv=gv", default_options)

-- Exit terminal mode
map("t", "<Esc><Esc>", "<C-\\><C-n>", { silent = true, desc = "Exit terminal mode" })

-- Light / dark
map("n", "<leader>ub", function()
    vim.o.background = vim.o.background == "dark" and "light" or "dark"
    vim.cmd.colorscheme("yev")
end, { silent = true, desc = "Toggle light/dark" })

-- Agents: references and diagnostics to paste into any agent
local agents = require("config.agents")

map({ "n", "v" }, "<leader>ay", agents.copy_reference, { silent = true, desc = "Copy @file#Lx-y reference" })
map("n", "<leader>ax", agents.copy_diagnostics, { silent = true, desc = "Copy diagnostics" })

-- Open lazygit in new terminal tab
local function open_lazygit()
    if vim.fn.executable("lazygit") ~= 1 then
        vim.notify("Can't find lazygit executable", vim.log.levels.ERROR)
        return
    end

    vim.cmd("tabnew")
    local lazygit_tab = vim.api.nvim_get_current_tabpage()

    vim.cmd("terminal lazygit")
    local lazygit_buffer = vim.api.nvim_get_current_buf()

    vim.api.nvim_create_autocmd("TermClose", {
        buffer = lazygit_buffer,
        once = true,
        callback = function()
            vim.schedule(function()
                if vim.api.nvim_tabpage_is_valid(lazygit_tab) then
                    vim.api.nvim_set_current_tabpage(lazygit_tab)
                    vim.cmd("tabclose")
                end
            end)
        end,
    })

    vim.cmd("startinsert")
end

vim.api.nvim_create_user_command("Lazygit", open_lazygit, { desc = "Open lazygit" })
map("n", "<leader>gg", open_lazygit, { silent = true, desc = "Open lazygit" })

-- Tasks
local tasks = require("config.tasks")

vim.api.nvim_create_user_command("Build", tasks.build, { desc = "Compile project" })
vim.api.nvim_create_user_command("Run", tasks.run, { desc = "Execute project" })
vim.api.nvim_create_user_command("Test", tasks.test, { desc = "Execute tests" })
vim.api.nvim_create_user_command("Lint", tasks.lint, { desc = "Lint project" })

vim.api.nvim_create_user_command("Task", function(options)
    tasks.task(options.args)
end, {
    nargs = "+",
    desc = "Execute command in root of the project",
})

map("n", "<leader>tb", tasks.build, { silent = true, desc = "Build project" })
map("n", "<leader>tr", tasks.run, { silent = true, desc = "Run project / dev server" })
map("n", "<leader>tt", tasks.test, { silent = true, desc = "Run tests" })
map("n", "<leader>tl", tasks.lint, { silent = true, desc = "Lint project" })
