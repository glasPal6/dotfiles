return {
	{
		"nvimdev/dashboard-nvim",
		event = "VimEnter",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"stevearc/oil.nvim",
		},
		config = function()
			require("dashboard").setup({
				change_to_vcs_root = true,
				config = {
					week_header = { enable = true },
					project = { action = "Oil" },
					shortcut = {},
				},
			})
		end,
	},
}
