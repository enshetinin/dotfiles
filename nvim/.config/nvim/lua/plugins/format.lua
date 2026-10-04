-- Biome when the project has a biome config, otherwise prettier.
-- Falls back to the LSP formatter (rustfmt, clang-format, lua_ls...).
local web = { "biome", "prettierd", "prettier", stop_after_first = true }

return {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    keys = {
        {
            "<leader>cf",
            function()
                require("conform").format({ async = true, lsp_format = "fallback" })
            end,
            mode = { "n", "v" },
            desc = "Format file",
        },
        {
            "<leader>uf",
            function()
                vim.g.disable_autoformat = not vim.g.disable_autoformat
                vim.notify("Format on save: " .. (vim.g.disable_autoformat and "off" or "on"))
            end,
            desc = "Toggle format on save",
        },
    },
    opts = {
        formatters_by_ft = {
            html = web,
            css = web,
            scss = web,
            less = web,
            javascript = web,
            javascriptreact = web,
            typescript = web,
            typescriptreact = web,
            vue = web,
            svelte = web,
            astro = web,
            json = web,
            jsonc = web,
            yaml = { "prettierd", "prettier", stop_after_first = true },
            graphql = { "prettierd", "prettier", stop_after_first = true },
            lua = { "stylua" },
        },
        formatters = {
            biome = {
                require_cwd = true,
            },
        },
        format_on_save = function()
            if vim.g.disable_autoformat then
                return nil
            end

            return { timeout_ms = 2000, lsp_format = "fallback" }
        end,
    },
}
