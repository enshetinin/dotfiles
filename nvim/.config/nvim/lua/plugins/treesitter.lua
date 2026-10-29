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

    -- Queries for mini.ai (vaf, cic...) + jumps between functions/classes
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        lazy = true,
        init = function()
            local function move(direction, query)
                return function()
                    require("nvim-treesitter-textobjects.move")[direction](query, "textobjects")
                end
            end
            local function map(keys, action, description)
                vim.keymap.set({ "n", "x", "o" }, keys, action, { desc = description })
            end

            map("]f", move("goto_next_start", "@function.outer"), "Next function")
            map("[f", move("goto_previous_start", "@function.outer"), "Previous function")
            map("]F", move("goto_next_end", "@function.outer"), "Next function end")
            map("[F", move("goto_previous_end", "@function.outer"), "Previous function end")
            map("]k", move("goto_next_start", "@class.outer"), "Next class")
            map("[k", move("goto_previous_start", "@class.outer"), "Previous class")
        end,
        opts = { move = { set_jumps = true } },
    },

    -- Close and rename HTML/JSX tags automatically
    {
        "windwp/nvim-ts-autotag",
        event = { "BufReadPre", "BufNewFile" },
        opts = {},
    },
}
