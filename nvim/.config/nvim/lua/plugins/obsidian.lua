return {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, the latest stabled
    lazy = true,
    ft = "markdown",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "hrsh7th/nvim-cmp",
    },
    opts = {
        workspaces = {
            {
                name = "yev",
                path = "~/Desktop/Obsidian/Yev"
            }
        },
        completion = {
            nvim_cmp = true,
            min_chars = 2
        },
        daily_notes = {
            folder = "notes/dailies",
            date_format = "%Y-%m-%d",
            default_tags = { "daily-notes" },
            template = nil
        },
        disable_frontmatter = false,
        ui = {
            -- render-markdown.nvim already handles rendering
            enable = false,
        },
    },
}
