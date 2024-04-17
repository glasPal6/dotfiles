return {
	"chentoast/marks.nvim",
	config = function()
		require("marks").setup({
			refresh_interval = 250,
			sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
			bookmark_0 = {
				sign = "⚑",
				virt_text = "",
				annotate = true,
			},
			mappings = {},
		})
	end,
}
