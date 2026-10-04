return {
    {
        "nvim-mini/mini.pairs",
        version = "*",
        event = "InsertEnter",
        opts = {},
    },

    -- Shows hex colors inline in CSS, Tailwind configs, tokens...
    {
        "nvim-mini/mini.hipatterns",
        version = "*",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            local hipatterns = require("mini.hipatterns")

            hipatterns.setup({
                highlighters = {
                    hex_color = hipatterns.gen_highlighter.hex_color(),
                },
            })
        end,
    },

    -- Keymap hints after <leader>, g, [ ], z...
    {
        "nvim-mini/mini.clue",
        version = "*",
        event = "VeryLazy",
        config = function()
            local clue = require("mini.clue")

            clue.setup({
                window = {
                    delay = 300,
                    config = { border = "single", width = "auto" },
                },
                triggers = {
                    { mode = "n", keys = "<Leader>" },
                    { mode = "x", keys = "<Leader>" },
                    { mode = "n", keys = "g" },
                    { mode = "x", keys = "g" },
                    { mode = "n", keys = "[" },
                    { mode = "n", keys = "]" },
                    { mode = "n", keys = "z" },
                    { mode = "n", keys = "<C-w>" },
                    { mode = "n", keys = "'" },
                    { mode = "n", keys = '"' },
                    { mode = "i", keys = "<C-r>" },
                },
                clues = {
                    { mode = "n", keys = "<Leader>a", desc = "+agents" },
                    { mode = "x", keys = "<Leader>a", desc = "+agents" },
                    { mode = "n", keys = "<Leader>c", desc = "+code" },
                    { mode = "n", keys = "<Leader>d", desc = "+debug" },
                    { mode = "n", keys = "<Leader>f", desc = "+find" },
                    { mode = "n", keys = "<Leader>g", desc = "+git" },
                    { mode = "n", keys = "<Leader>m", desc = "+markdown" },
                    { mode = "n", keys = "<Leader>t", desc = "+tasks" },
                    { mode = "n", keys = "<Leader>u", desc = "+ui" },
                    clue.gen_clues.builtin_completion(),
                    clue.gen_clues.g(),
                    clue.gen_clues.marks(),
                    clue.gen_clues.registers(),
                    clue.gen_clues.windows(),
                    clue.gen_clues.z(),
                },
            })
        end,
    },
}
