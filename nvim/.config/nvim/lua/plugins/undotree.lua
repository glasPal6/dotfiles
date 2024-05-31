return {
	"jiaoshijie/undotree",
	dependencies = "nvim-lua/plenary.nvim",
	keys = { -- load the plugin only when using it's keybinding:
		{ "<leader>u", "<cmd>lua require('undotree').toggle()<cr>" },
	},
	config = function()
		require("undotree").setup({
            float_diff = false,
			keymaps = {
				["<Down>"] = "move_next",
				["<Up>"] = "move_prev",
				["g<Down>"] = "move2parent",
				["<C-Down>"] = "move_change_next",
				["<C-Up>"] = "move_change_prev",
				["<cr>"] = "action_enter",
				["p"] = "enter_diffbuf",
			},
		})
	end,
}
