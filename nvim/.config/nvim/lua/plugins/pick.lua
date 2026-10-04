return {
    "nvim-mini/mini.pick",
    -- use stable version
    version = "*",
    config = function()
        local pick = require("mini.pick")
        pick.setup({
            window = {
                config = function()
                    local height = math.floor(vim.o.lines * 0.45)
                    local width = math.floor(vim.o.columns * 0.55)

                    -- Anchored left of center: asymmetric, not a centered modal
                    return {
                        border = "single",
                        anchor = "NW",
                        row = math.floor((vim.o.lines - height) * 0.35),
                        col = math.floor(vim.o.columns * 0.12),
                        height = height,
                        width = width,
                    }
                end,
                prompt_prefix = "› ",
            },
        })

        vim.ui.select = pick.ui_select

        local function map(keys, action, description)
            vim.keymap.set("n", keys, action, { silent = true, desc = description })
        end

        map("<leader>ff", function()
            pick.builtin.files()
        end, "Search archives")

        map("<leader>fg", function()
            if vim.fn.executable("rg") ~= 1 then
                vim.notify(
                    "ripgrep is required for this action. Can be installed via brew install ripgrep",
                    vim.log.levels.WARN
                )
                return
            end

            pick.builtin.grep_live()
        end, "Search for text")

        map("<leader>fb", function()
            pick.builtin.buffers()
        end, "Search for buffers")

        map("<leader>fh", function()
            pick.builtin.help()
        end, "Search for help")

        map("<leader>fr", function()
            pick.builtin.resume()
        end, "Resume last search")

        map("<leader>fw", function()
            pick.builtin.grep({ pattern = vim.fn.expand("<cword>") })
        end, "Search word under cursor")
    end
}
