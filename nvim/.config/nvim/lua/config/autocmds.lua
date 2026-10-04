local group = vim.api.nvim_create_augroup("yev-autocmds", { clear = true })

-- Agents (Claude Code, etc.) write files from outside nvim.
-- Check the disk whenever we come back to nvim or stop typing.
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "TermLeave" }, {
    group = group,
    callback = function()
        if vim.fn.mode() ~= "c" and vim.fn.getcmdwintype() == "" then
            vim.cmd("checktime")
        end
    end,
})

vim.api.nvim_create_autocmd("FileChangedShellPost", {
    group = group,
    callback = function(event)
        vim.notify(
            "Recargado desde disco: " .. vim.fn.fnamemodify(event.file, ":~:."),
            vim.log.levels.INFO
        )
    end,
})

-- Frontend code is usually indented with 2 spaces.
-- An .editorconfig in the project still has the last word.
vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = {
        "html",
        "css",
        "scss",
        "less",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "vue",
        "svelte",
        "astro",
        "json",
        "jsonc",
        "yaml",
        "markdown",
    },
    callback = function(event)
        local editorconfig = vim.b[event.buf].editorconfig or {}

        if editorconfig.indent_size or editorconfig.indent_style then
            return
        end

        vim.bo[event.buf].tabstop = 2
        vim.bo[event.buf].shiftwidth = 2
        vim.bo[event.buf].softtabstop = 2
    end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
    group = group,
    callback = function()
        vim.hl.on_yank({ higroup = "Visual", timeout = 150 })
    end,
})

vim.api.nvim_create_autocmd("TermOpen", {
    group = group,
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.signcolumn = "no"
        vim.opt_local.list = false
    end,
})

-- Keep splits proportional when the terminal is resized
vim.api.nvim_create_autocmd("VimResized", {
    group = group,
    command = "wincmd =",
})
