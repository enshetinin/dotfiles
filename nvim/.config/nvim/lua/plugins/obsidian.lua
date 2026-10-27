-- Community fork (the original epwalsh/obsidian.nvim is archived). Uses blink.cmp.
return {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    ft = "markdown",
    opts = {
        legacy_commands = false,
        workspaces = {
            { name = "yev", path = "~/Desktop/Obsidian/Yev" },
        },
        completion = {
            blink = true,
            nvim_cmp = false,
            min_chars = 2,
        },
        daily_notes = {
            folder = "notes/dailies",
            date_format = "%Y-%m-%d",
            default_tags = { "daily-notes" },
        },
        -- render-markdown.nvim already handles rendering
        ui = { enable = false },
    },
}
