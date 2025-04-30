return {

	{
		"hedyhli/outline.nvim",
		lazy = true,
		cmd = { "Outline", "OutlineOpen" },
		keys = {
			{ "<leader>fo", "<cmd>Outline<CR>", desc = "Toggle outline" },
		},
		opts = {},
	},
}
