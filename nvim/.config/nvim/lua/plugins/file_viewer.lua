return {

	-- Oil
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		-- event = { "VeryLazy" },
		opts = {},
		config = function()
			require("oil").setup({
				default_file_explorer = true,
				delete_to_trash = true,
				columns = {
					"permissions",
					"size",
					"mtime",
					"icon",
				},
				skip_confirm_for_simple_edits = true,
				view_options = {
					show_hidden = true,
				},
				constrain_cursor = "name",
			})
			vim.keymap.set("n", "-", "<CMD>Oil<CR>", { silent = true, desc = "Open parent directory" })
		end,
	},

	-- Neotree
	-- {
	-- 	"nvim-neo-tree/neo-tree.nvim",
	-- 	branch = "v3.x",
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim",
	-- 		"MunifTanjim/nui.nvim",
	-- 		"nvim-tree/nvim-web-devicons", -- optional, but recommended
	-- 	},
	-- 	lazy = false, -- neo-tree will lazily load itself
	-- 	config = function()
	-- 		require("neo-tree").setup()
	-- 		vim.keymap.set(
	-- 			"n",
	-- 			"ft",
	-- 			"<CMD>Neotree position=float<CR>",
	-- 			{ silent = true, desc = "Open parent directory" }
	-- 		)
	-- 	end,
	-- },
	-- {
	-- 	"Crysthamus/nvim-file-operations",
	-- 	dependencies = {
	-- 		-- Uncomment whichever supported plugin(s) you use
	-- 		-- "nvim-tree/nvim-tree.lua",
	-- 		"nvim-neo-tree/neo-tree.nvim",
	-- 		-- "simonmclean/triptych.nvim"
	-- 	},
	-- 	config = function()
	-- 		require("nvim-file-operations").setup({
	-- 			-- Select which file operations to enable
	-- 			operations = {
	-- 				willRenameFiles = true,
	-- 				didRenameFiles = true,
	-- 				willCreateFiles = true,
	-- 				didCreateFiles = true,
	-- 				willDeleteFiles = true,
	-- 				didDeleteFiles = true,
	-- 			},
	-- 			-- How long to wait (in milliseconds) for LSP responses before cancelling
	-- 			timeout_ms = 10000,
	-- 			-- Saves modifies files after renames, moves, etc.
	-- 			auto_save = false,
	-- 		})
	-- 		vim.lsp.config("*", {
	-- 			capabilities = require("nvim-file-operations.config").default_capabilities(),
	-- 		})
	-- 	end,
	-- },

	-- Dashboard
	-- {
	-- 	"goolord/alpha-nvim",
	-- 	dependencies = {
	-- 		-- "nvim-telescope/telescope.nvim",
	-- 		"ibhagwan/fzf-lua",
	-- 		"nvim-lua/plenary.nvim",
	-- 	},
	-- 	event = "VimEnter",
	-- 	config = function()
	-- 		local alpha = require("alpha")
	-- 		local dashboard = require("alpha.themes.dashboard")
	--
	-- 		-- Optional ASCII header
	-- 		dashboard.section.header.val = {
	-- 			"  .___________. __    __   _______     _______  _______   __  .___________.  ______   .______        ",
	-- 			"  |           ||  |  |  | |   ____|   |   ____||        |  | |           | /  __    |   _         ",
	-- 			"  `---|  |----`|  |__|  | |  |__      |  |__   |  .--.  ||  | `---|  |----`|  |  |  | |  |_)  |      ",
	-- 			"      |  |     |   __   | |   __|     |   __|  |  |  |  ||  |     |  |     |  |  |  | |      /       ",
	-- 			"      |  |     |  |  |  | |  |____    |  |____ |  '--'  ||  |     |  |     |  `--'  | |  |  ----.  ",
	-- 			"      |__|     |__|  |__| |_______|   |_______||_______/ |__|     |__|      ______/  | _| `._____|  ",
	-- 			"                                                                                                     ",
	-- 		}
	--
	-- 		-- Dashboard buttons
	-- 		dashboard.section.buttons.val = {
	-- 			dashboard.button("f", "  Find File", ":FzfLua files<CR>"),
	-- 			dashboard.button("o", "  Open files", ":Neotree position=float<CR>"),
	-- 			dashboard.button("n", "  New File", ":ene <BAR> startinsert <CR>"),
	-- 			dashboard.button("q", "  Quit", ":qa<CR>"),
	-- 		}
	--
	-- 		dashboard.section.footer.val = "Happy Coding 🚀"
	--
	-- 		alpha.setup(dashboard.config)
	-- 	end,
	-- },
}
