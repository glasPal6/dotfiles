return {
	{
		"stevearc/oil.nvim",
		opts = {},
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("oil").setup({
				default_file_explorer = true,
				-- Id is automatically added at the beginning, and name at the end
				-- See :help oil-columns
				columns = {
					"icon",
					"permissions",
					"size",
					"mtime",
				},
				skip_confirm_for_simple_edits = true,
				view_options = {
					-- Show files and directories that start with "."
					show_hidden = true,
				},
			})
			vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
		end,
	},
}
