-- Everything you see: dashboard, picker, notifications, cmdline, keymap hints.

local logo = {
    "██╗   ██╗███████╗██╗   ██╗",
    "╚██╗ ██╔╝██╔════╝██║   ██║",
    " ╚████╔╝ █████╗  ██║   ██║",
    "  ╚██╔╝  ██╔══╝  ╚██╗ ██╔╝",
    "   ██║   ███████╗ ╚████╔╝ ",
    "   ╚═╝   ╚══════╝  ╚═══╝  ",
}

local function today()
    local days = { "domingo", "lunes", "martes", "miércoles", "jueves", "viernes", "sábado" }
    local months = { "enero", "febrero", "marzo", "abril", "mayo", "junio", "julio",
        "agosto", "septiembre", "octubre", "noviembre", "diciembre" }
    local now = os.date("*t")
    return days[now.wday] .. " " .. now.day .. " de " .. months[now.month]
end

-- One dashboard item per logo line so each line gets its gradient color
local function header()
    local sections = {}
    for index, line in ipairs(logo) do
        table.insert(sections, { text = { { line, hl = "YevGrad" .. index } }, align = "center" })
    end
    table.insert(sections, {
        text = { { "neovim · " .. today(), hl = "SnacksDashboardFooter" } },
        align = "center",
        padding = 2,
    })
    return sections
end

local function pick(source, options)
    return function()
        Snacks.picker[source](options)
    end
end

return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            bigfile = { enabled = true },
            quickfile = { enabled = true },
            input = { enabled = true },
            words = { enabled = true },
            scope = { enabled = true },
            statuscolumn = { enabled = true },
            scroll = {
                enabled = true,
                animate = { duration = { step = 12, total = 180 }, easing = "outQuad" },
            },
            indent = {
                enabled = true,
                indent = { char = "│" },
                scope = { char = "│", hl = "SnacksIndentScope" },
                animate = { duration = { step = 15, total = 250 } },
            },
            notifier = {
                enabled = true,
                timeout = 3000,
                style = "fancy",
                top_down = false,
            },
            explorer = { replace_netrw = false },
            lazygit = { configure = true },
            terminal = { win = { border = "rounded" } },
            zen = { toggles = { dim = true }, win = { backdrop = { transparent = false } } },
            picker = {
                prompt = " \u{f002}  ",
                layout = { preset = "telescope" },
                matcher = { frecency = true },
                formatters = { file = { filename_first = true } },
                sources = {
                    files = { hidden = true },
                    grep = { hidden = true },
                    smart = { hidden = true },
                    explorer = { hidden = true, layout = { preset = "sidebar", preview = false } },
                },
            },
            dashboard = {
                preset = {
                    keys = {
                        { icon = "\u{f002} ", key = "f", desc = "Buscar archivo", action = ":lua Snacks.picker.smart()" },
                        { icon = "\u{f0b0} ", key = "g", desc = "Buscar texto", action = ":lua Snacks.picker.grep()" },
                        { icon = "\u{f1da} ", key = "r", desc = "Recientes", action = ":lua Snacks.picker.recent()" },
                        { icon = "\u{f15b} ", key = "n", desc = "Nuevo archivo", action = ":ene | startinsert" },
                        { icon = "󰚩 ", key = "a", desc = "Claude Code", action = ":ClaudeCode" },
                        { icon = "\u{e702} ", key = "G", desc = "Lazygit", action = ":lua Snacks.lazygit()" },
                        { icon = "\u{f013} ", key = "c", desc = "Config", action = ":lua Snacks.picker.files({ cwd = vim.fn.stdpath('config') })" },
                        { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy" },
                        { icon = "\u{f011} ", key = "q", desc = "Salir", action = ":qa" },
                    },
                },
                sections = vim.list_extend(header(), {
                    { section = "keys", gap = 1, padding = 2 },
                    { icon = "\u{f1da} ", title = "Recientes", section = "recent_files", cwd = true, limit = 5, indent = 2, padding = 2 },
                    { section = "startup" },
                }),
            },
        },
        keys = {
            -- Find
            { "<leader><space>", pick("smart"), desc = "Smart find" },
            { "<leader>ff", pick("files"), desc = "Files" },
            { "<leader>fg", pick("grep"), desc = "Grep" },
            { "<leader>fw", pick("grep_word"), desc = "Grep word / selection", mode = { "n", "x" } },
            { "<leader>fb", pick("buffers"), desc = "Buffers" },
            { "<leader>fr", pick("resume"), desc = "Resume last search" },
            { "<leader>fo", pick("recent"), desc = "Recent files" },
            { "<leader>fh", pick("help"), desc = "Help" },
            { "<leader>fk", pick("keymaps"), desc = "Keymaps" },
            { "<leader>fd", pick("diagnostics"), desc = "Diagnostics" },
            { "<leader>fu", pick("undo"), desc = "Undo history" },
            { "<leader>fn", pick("notifications"), desc = "Notifications" },
            { "<leader>fc", pick("files", { cwd = vim.fn.stdpath("config") }), desc = "Config files" },
            { "<leader>f/", pick("lines"), desc = "Lines in buffer" },
            { "<leader>e", function() Snacks.explorer() end, desc = "File tree" },

            -- Git
            { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
            { "<leader>gl", pick("git_log"), desc = "Git log" },
            { "<leader>gf", function() Snacks.lazygit.log_file() end, desc = "Lazygit file history" },
            { "<leader>gS", pick("git_status"), desc = "Git status" },
            { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Open in browser", mode = { "n", "v" } },

            -- Buffers, terminal, UI
            { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete buffer" },
            { "<leader>bo", function() Snacks.bufdelete.other() end, desc = "Delete other buffers" },
            { "<C-/>", function() Snacks.terminal() end, desc = "Terminal", mode = { "n", "t" } },
            { "<leader>z", function() Snacks.zen() end, desc = "Zen mode" },
            { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss notifications" },
            { "<leader>uh", pick("highlights"), desc = "Highlight groups" },
            { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next reference" },
            { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Previous reference" },
        },
        init = function()
            vim.api.nvim_create_autocmd("User", {
                pattern = "VeryLazy",
                callback = function()
                    vim.api.nvim_create_user_command("Lazygit", function() Snacks.lazygit() end, {})
                    Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
                    Snacks.toggle.option("relativenumber", { name = "Relative number" }):map("<leader>ul")
                    Snacks.toggle.diagnostics():map("<leader>ud")
                    Snacks.toggle.indent():map("<leader>ug")
                    Snacks.toggle.dim():map("<leader>uD")
                end,
            })
        end,
    },

    -- Floating cmdline and search, messages in the corner
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = { "MunifTanjim/nui.nvim" },
        opts = {
            cmdline = { view = "cmdline_popup" },
            messages = { view = "mini", view_warn = "mini", view_error = "mini" },
            popupmenu = { backend = "nui" },
            -- snacks.notifier owns vim.notify; blink.cmp owns signature/docs
            notify = { enabled = false },
            lsp = {
                progress = { enabled = true, view = "mini" },
                hover = { enabled = false },
                signature = { enabled = false },
                message = { enabled = false },
            },
            presets = {
                bottom_search = false,
                command_palette = true,
                long_message_to_split = true,
            },
            views = {
                cmdline_popup = { border = { style = "rounded" } },
                popupmenu = { border = { style = "rounded" } },
                mini = { win_options = { winblend = 0 } },
            },
        },
    },

    -- Keymap hints after <leader>, g, [, ], z...
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            preset = "helix",
            delay = 300,
            win = { border = "rounded", title_pos = "center" },
            spec = {
                { "<leader>a", group = "agents", icon = "󰚩 ", mode = { "n", "x" } },
                { "<leader>b", group = "buffers", icon = "\u{f0c5} " },
                { "<leader>c", group = "code", icon = "\u{f121} " },
                { "<leader>d", group = "debug", icon = "\u{f188} " },
                { "<leader>f", group = "find", icon = "\u{f002} " },
                { "<leader>g", group = "git", icon = "\u{e702} " },
                { "<leader>m", group = "markdown", icon = "\u{f48a} " },
                { "<leader>t", group = "tasks", icon = "\u{f0ae} " },
                { "<leader>u", group = "ui", icon = "󰙵 " },
            },
        },
    },

    -- Icons (mini.icons also answers nvim-web-devicons calls)
    {
        "nvim-mini/mini.icons",
        version = "*",
        lazy = true,
        opts = {},
        init = function()
            package.preload["nvim-web-devicons"] = function()
                require("mini.icons").mock_nvim_web_devicons()
                return package.loaded["nvim-web-devicons"]
            end
        end,
    },

    -- Animated cursor trail
    {
        "sphamba/smear-cursor.nvim",
        event = "VeryLazy",
        opts = {
            cursor_color = "#FF4D1F",
            stiffness = 0.7,
            trailing_stiffness = 0.45,
            distance_stop_animating = 0.5,
            smear_insert_mode = false,
        },
        keys = {
            { "<leader>us", function() require("smear_cursor").toggle() end, desc = "Toggle cursor trail" },
        },
    },
}
