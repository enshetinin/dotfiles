return {
    "kevalin/mermaid.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = { "markdown", "mermaid" },
    config = function()
        require("mermaid").setup()
    end
}
