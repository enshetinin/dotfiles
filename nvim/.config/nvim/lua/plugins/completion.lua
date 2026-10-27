-- Completion menu with icons, docs and signature help.
return {
    "saghen/blink.cmp",
    version = "1.*",
    event = "InsertEnter",
    opts = {
        -- <C-y> accept · <C-n>/<C-p> move · <C-space> open · <C-e> close · <Tab> snippet jump
        keymap = { preset = "default" },
        appearance = { nerd_font_variant = "mono" },
        completion = {
            list = { selection = { preselect = true, auto_insert = false } },
            menu = {
                border = "rounded",
                scrollbar = false,
                draw = {
                    treesitter = { "lsp" },
                    columns = {
                        { "kind_icon" },
                        { "label", "label_description", gap = 1 },
                        { "kind" },
                    },
                },
            },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 200,
                window = { border = "rounded" },
            },
            ghost_text = { enabled = true },
        },
        signature = { enabled = true, window = { border = "rounded" } },
        sources = { default = { "lsp", "path", "snippets", "buffer" } },
        fuzzy = { implementation = "prefer_rust_with_warning" },
        -- The cmdline is drawn by noice
        cmdline = { enabled = false },
    },
}
