return {
	{
		"goolord/alpha-nvim",
		dependencies = {
			-- "nvim-telescope/telescope.nvim",
			"ibhagwan/fzf-lua",
			"nvim-lua/plenary.nvim",
			"stevearc/oil.nvim",
		},
		event = "VimEnter",
		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")

			-- Optional ASCII header
			dashboard.section.header.val = {
				"  .___________. __    __   _______     _______  _______   __  .___________.  ______   .______        ",
				"  |           ||  |  |  | |   ____|   |   ____||        |  | |           | /  __    |   _         ",
				"  `---|  |----`|  |__|  | |  |__      |  |__   |  .--.  ||  | `---|  |----`|  |  |  | |  |_)  |      ",
				"      |  |     |   __   | |   __|     |   __|  |  |  |  ||  |     |  |     |  |  |  | |      /       ",
				"      |  |     |  |  |  | |  |____    |  |____ |  '--'  ||  |     |  |     |  `--'  | |  |  ----.  ",
				"      |__|     |__|  |__| |_______|   |_______||_______/ |__|     |__|      ______/  | _| `._____|  ",
				"                                                                                                     ",
			}

			-- Dashboard buttons
			dashboard.section.buttons.val = {
				dashboard.button("f", "  Find File", ":FzfLua files<CR>"),
				dashboard.button("o", "  Open Oil", ":Oil<CR>"),
				dashboard.button("n", "  New File", ":ene <BAR> startinsert <CR>"),
				dashboard.button("q", "  Quit", ":qa<CR>"),
			}

			dashboard.section.footer.val = "Happy Coding 🚀"

			alpha.setup(dashboard.config)
		end,
	},
}
