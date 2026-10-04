return {
    "lewis6991/gitsigns.nvim",
    version = "v2.1.0",
    event = {
        "BufReadPre",
        "BufNewFile"
    },
    opts = {
        -- show new files that are not added to git
        attach_to_untracked = true,

        signs = {
            add = { text = "▎" },
            change = { text = "╎" },
            delete = { text = "▁" },
            topdelete = { text = "▔" },
            changedelete = { text = "╎" },
            untracked = { text = "┆" },
        },

        -- don't show blame permanenty
        current_line_blame = false,

        numhl = false,
        linehl = false,
        word_diff = false,

        preview_config = {
            border = "single"
        },

        on_attach = function(buffer)
            local gitsigns = require("gitsigns")

            local function map(mode, keys, action, description)
                vim.keymap.set(mode, keys, action, {
                    buffer = buffer,
                    silent = true,
                    desc = "Git: " .. description
                })
            end

            -- Navegation between changes
            map("n", "]h", function()
                if vim.wo.diff then
                    vim.cmd.normal({ "]c", bang = true })
                else
                    gitsigns.nav_hunk("next")
                end
            end, "Next change")

            map("n", "[h", function()
                if vim.wo.diff then
                    vim.cmd.normal({ "[c", bang = true })
                else
                    gitsigns.nav_hunk("prev")
                end
            end, "Prev change")

            -- Acction on actual change
            map(
                "n",
                "<leader>gp",
                "<cmd>Gitsigns preview_hunk<CR>",
                "Previsualize change"
            )

            map(
                "n",
                "<leader>gs",
                "<cmd>Gitsigns stage_hunk<CR>",
                "Stage or unstage of the change"
            )

            map(
                "n",
                "<leader>gu",
                "<cmd>Gitsigns undo_stage_hunk<CR>",
                "Undo last stage"
            )

            map(
                "n",
                "<leader>gr",
                "<cmd>Gitsigns reset_hunk<CR>",
                "Discard change"
            )


            -- Information and differences
             map(
                "n",
                "<leader>gb",
                "<cmd>Gitsigns blame_line full=true<CR>",
                "Show blame of the line"
            )

            map(
                "n",
                "<leader>gd",
                "<cmd>Gitsigns diffthis<CR>",
                "Show diff of the archive"
            )

            map(
                "n",
                "<leader>gq",
                "<cmd>Gitsigns setqflist<CR>",
                "Changes of the archive in quickfix"
            )

            -- Visual selection
            map("v", "<leader>gs", function()
                gitsigns.stage_hunk({
                    vim.fn.line("."),
                    vim.fn.line("v"),
                })
            end, "Stage of the selection")

            map("v", "<leader>gr", function()
                gitsigns.reset_hunk({
                    vim.fn.line("."),
                    vim.fn.line("v"),
                })
            end, "Discard selection")

        end
    }
}
