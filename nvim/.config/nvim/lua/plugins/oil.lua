return {
	"stevearc/oil.nvim",
	lazy = false,
	opts = {
		default_file_explorer = true,
		columns = { "icon" },
		float = { border = "rounded", padding = 2 },
		view_options = {
			show_hidden = true
		},
		win_options = {
			signcolumn = "no"
		}
	},
	keys = {
		{
			"-",
			"<cmd>Oil --float<CR>",
			desc = "Open Oil"
		}
	}
}
