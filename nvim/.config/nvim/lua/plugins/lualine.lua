return {

	-- Show cool stuff in the lualine
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		config = function()
			require("lualine").setup({
				options = {
					theme = "auto",
					component_separators = "",
					section_separators = { right = "", left = "" },
				},
				sections = {
					lualine_a = { { "mode", separator = { left = "", right = "" } } },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = {
						"filename",
						"grapple",
						-- "overseer",
					},
					lualine_x = {
						"encoding",
						"fileformat",
						"filetype",
					},
					lualine_y = { "progress" },
					lualine_z = { { "location", separator = { left = "", right = "" } } },
				},
			})
		end,
	},
}
