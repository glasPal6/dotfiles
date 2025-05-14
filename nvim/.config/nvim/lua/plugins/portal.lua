return {

	{
		"cbochs/portal.nvim",
		event = "VeryLazy",
		dependencies = {
			"cbochs/grapple.nvim",
		},
		keys = {
			{ "<leader>o", "<cmd>Portal jumplist backward<cr>", { silent = true } },
			{ "<leader>i", "<cmd>Portal jumplist forward<cr>", { silent = true } },
		},
		opts = {
			labels = { "a", "e", "i", "h" },
		},
	},
}
