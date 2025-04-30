return {

	-- Show the undo tree
	{
		"jiaoshijie/undotree",
		-- event = "VeryLazy",
		dependencies = "nvim-lua/plenary.nvim",
		keys = { -- load the plugin only when using it's keybinding:
			{ "<leader>u", "<cmd>lua require('undotree').toggle()<cr>", silent = true },
		},
		config = function()
			require("undotree").setup({
				float_diff = false,
				keymaps = {
					["<Down>"] = "move_next",
					["<Up>"] = "move_prev",
					["g<Down>"] = "move2parent",
					["<AC-Down>"] = "move_change_next",
					["<AC-Up>"] = "move_change_prev",
					["<cr>"] = "action_enter",
					["p"] = "enter_diffbuf",
				},
			})
		end,
	},
}
