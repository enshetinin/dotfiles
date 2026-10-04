local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local uv = vim.uv or vim.loop

if not uv.fs_stat(lazypath) then
    local repository = "https://github.com/folke/lazy.nvim.git"

    local output = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        repository,
        lazypath,
    })

    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            {
                "No se pudo instalar lazy.nvim:\n",
                "ErrorMsg",
            },
            {
                output,
                "WarningMsg",
            },
        }, true, {})

        return
    end
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = {
        {
            import = "plugins",
        },
    },

    install = {
        colorscheme = { "yev" },
    },

    checker = {
        enabled = false,
    },

    change_detection = {
        notify = false,
    },

    ui = {
        border = "single",
    },
})

