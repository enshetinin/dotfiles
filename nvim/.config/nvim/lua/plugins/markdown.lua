return {
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        ft = { "markdown" },
        opts = {
            completions = {
                lsp = { enabled = true },
            },
            -- Typographic headings: no colored bands, no icons
            heading = {
                sign = false,
                icons = {},
                width = "block",
                backgrounds = {},
            },
            code = {
                sign = false,
                border = "thin",
                width = "block",
                left_pad = 2,
                right_pad = 2,
            },
            bullet = {
                icons = { "–", "·", "–", "·" },
            },
        },
        keys = {
            {
                "<leader>mt",
                function()
                    require("render-markdown").buf_toggle()
                end,
                desc = "Markdown: alternar renderizado",
            },
            {
                "<leader>me",
                function()
                    require("render-markdown").expand()
                end,
                desc = "Markdown: expandir texto original",
            },
            {
                "<leader>mc",
                function()
                    require("render-markdown").contract()
                end,
                desc = "Markdown: contraer texto original",
            },
        },
    },

    {
        -- Comment for now, waiting mainteiners to acept PR for mermaid 11.12
        --"toppair/peek.nvim",

        "niko-holmes/peek.nvim",
        name = "peek.nvim",
        commit = "08094803e322ece6c1b562d0f6bdbe80215df4f1",

        ft = { "markdown" },
        build = "deno task --quiet build:fast",
        config = function()
            require("peek").setup({
                auto_load = true,
                close_on_bdelete = true,
                syntax = true,
                theme = vim.o.background,
                update_on_change = true,

                -- "browser" abre el navegador predeterminado.
                -- También puedes probar "webview".
                app = "browser",
            })
        end,
        keys = {
            {
                "<leader>mp",
                function()
                    local peek = require("peek")

                    if peek.is_open() then
                        peek.close()
                    else
                        peek.open()
                    end
                end,
                desc = "Markdown: alternar preview con Mermaid",
            },
        },
    },
}
