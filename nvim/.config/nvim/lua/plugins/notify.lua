return {

	-- Notifications
	{
		"rcarriga/nvim-notify",
		event = "VeryLazy",
		config = function()
			require("notify").setup({
				render = "wrapped-compact",
				stages = "fade_in_slide_out",
				background_colour = "FloatShadow",
				timeout = 3000,
			})
			vim.notify = require("notify")
		end,
	},
}
