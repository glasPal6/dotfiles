return {
	{
		"cbochs/portal.nvim",
		dependencies = {
			"cbochs/grapple.nvim",
		},
		keys = {
			{ "<leader>o", "<cmd>Portal jumplist backward<cr>" },
			{ "<leader>i", "<cmd>Portal jumplist forward<cr>" },
		},
		opts = {
			labels = { "a", "e", "i", "h" },
		},
	},
}
