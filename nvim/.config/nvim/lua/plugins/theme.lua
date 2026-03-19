return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				-- Options here: latte, frappe, macchiato, mocha
				flavour = "mocha",
				background = { light = "latte", dark = "mocha" },
				transparent_background = false,
				term_colors = true,
				styles = {
					comments = { "italic" },
					conditionals = { "italic" },
				},
			})

			-- Load the colorscheme
			vim.cmd.colorscheme("catppuccin")
		end,
	},
}
