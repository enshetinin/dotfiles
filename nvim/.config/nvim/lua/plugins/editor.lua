return {
    {
        "nvim-mini/mini.pairs",
        version = "*",
        event = "InsertEnter",
        opts = {},
    },

    -- Hex colors painted inline + TODO/FIXME/HACK/NOTE badges
    {
        "nvim-mini/mini.hipatterns",
        version = "*",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            local hipatterns = require("mini.hipatterns")
            local function word(name)
                return "%f[%w]()" .. name .. "()%f[%W]"
            end

            hipatterns.setup({
                highlighters = {
                    todo = { pattern = word("TODO"), group = "MiniHipatternsTodo" },
                    fixme = { pattern = word("FIXME"), group = "MiniHipatternsFixme" },
                    hack = { pattern = word("HACK"), group = "MiniHipatternsHack" },
                    note = { pattern = word("NOTE"), group = "MiniHipatternsNote" },
                    hex_color = hipatterns.gen_highlighter.hex_color(),
                },
            })
        end,
    },

    -- Surround under gs (s belongs to flash): gsa add, gsd delete, gsr replace
    {
        "nvim-mini/mini.surround",
        version = "*",
        keys = {
            { "gsa", mode = { "n", "x" }, desc = "Add surrounding" },
            { "gsd", desc = "Delete surrounding" },
            { "gsr", desc = "Replace surrounding" },
            { "gsf", desc = "Find surrounding (right)" },
            { "gsF", desc = "Find surrounding (left)" },
            { "gsh", desc = "Highlight surrounding" },
        },
        opts = {
            mappings = {
                add = "gsa",
                delete = "gsd",
                replace = "gsr",
                find = "gsf",
                find_left = "gsF",
                highlight = "gsh",
                update_n_lines = "",
                suffix_last = "l",
                suffix_next = "n",
            },
        },
    },

    -- Jump anywhere on screen: s + 2 letters + label.
    -- S selects treesitter nodes; in operator mode r = remote (e.g. yr<jump>iw)
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {
            modes = {
                -- f/t/;/, keep their native behaviour
                char = { enabled = false },
            },
        },
        keys = {
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
            { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash treesitter" },
            { "r", mode = "o", function() require("flash").remote() end, desc = "Remote flash" },
            { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter search" },
            { "<C-s>", mode = "c", function() require("flash").toggle() end, desc = "Toggle flash search" },
        },
    },

    -- Better a/i textobjects. Code-aware ones come from treesitter:
    --   f function · c class · o block/if/loop · a argument · u call · t tag
    --   e.g. vaf (whole function), cif (function body), dia (argument)
    -- n/l suffix targets the next/last one: cinf, dalf...
    {
        "nvim-mini/mini.ai",
        version = "*",
        event = "VeryLazy",
        dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
        opts = function()
            local ai = require("mini.ai")
            return {
                n_lines = 500,
                custom_textobjects = {
                    f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
                    c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
                    o = ai.gen_spec.treesitter({
                        a = { "@block.outer", "@conditional.outer", "@loop.outer" },
                        i = { "@block.inner", "@conditional.inner", "@loop.inner" },
                    }),
                    u = ai.gen_spec.function_call(),
                    t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
                },
            }
        end,
    },
}
