return {
	-- {
	-- 	"chentoast/marks.nvim",
	-- 	config = function()
	-- 		require("marks").setup({
	-- 			refresh_interval = 250,
	-- 			sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
	-- 			bookmark_0 = {
	-- 				sign = "⚑",
	-- 				virt_text = "",
	-- 				annotate = true,
	-- 			},
	-- 			mappings = {},
	-- 		})
	-- 		vim.keymap.set("n", "<leader>m", vim.cmd.MarksListAll)
	-- 		vim.keymap.set("n", "<leader>b", vim.cmd.BookmarksListAll)

	-- 		for i = 0, 9 do
	-- 			vim.keymap.set("n", "<leader>b" .. tostring(i), ":BookmarksList " .. tostring(i) .. "<CR>")
	-- 		end
	-- 	end,
	-- },
	{
		"cbochs/grapple.nvim",
		opts = {
			-- scope = "git", -- also try out "git_branch"
		},
		event = { "BufReadPost", "BufNewFile" },
		cmd = "Grapple",
		keys = {
			{ "<leader>m", "<cmd>Grapple toggle<cr>", desc = "Grapple toggle tag" },
			{ "<leader>M", "<cmd>Grapple toggle_tags<cr>", desc = "Grapple open tags window" },
			{ "<leader>n", "<cmd>Grapple cycle_tags next<cr>", desc = "Grapple cycle next tag" },
			{ "<leader>p", "<cmd>Grapple cycle_tags prev<cr>", desc = "Grapple cycle previous tag" },
		},
	},
}
