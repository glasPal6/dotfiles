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
}
