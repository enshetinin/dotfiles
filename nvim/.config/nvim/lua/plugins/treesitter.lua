local parsers = {
    -- frontend
    "html",
    "css",
    "scss",
    "javascript",
    "typescript",
    "tsx",
    "jsdoc",
    "json",
    "astro",
    "svelte",
    "vue",
    "graphql",
    -- systems
    "c",
    "cpp",
    "rust",
    "lua",
    -- tooling and notes
    "bash",
    "yaml",
    "toml",
    "regex",
    "diff",
    "gitcommit",
    "markdown",
    "markdown_inline",
    "mermaid",
    "vim",
    "vimdoc",
}

return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter").install(parsers)

            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("yev-treesitter", { clear = true }),
                callback = function(event)
                    if not pcall(vim.treesitter.start, event.buf) then
                        return
                    end

                    vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end,
            })
        end,
    },

    -- Close and rename HTML/JSX tags automatically
    {
        "windwp/nvim-ts-autotag",
        event = { "BufReadPre", "BufNewFile" },
        opts = {},
    },
}
