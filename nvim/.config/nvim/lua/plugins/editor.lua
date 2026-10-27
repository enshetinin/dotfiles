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

    -- Surround: sa (add), sd (delete), sr (replace)
    {
        "nvim-mini/mini.surround",
        version = "*",
        keys = { "sa", "sd", "sr", "sf", "sh" },
        opts = {},
    },
}
