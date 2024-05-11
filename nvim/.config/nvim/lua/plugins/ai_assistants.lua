return {
	{
		"Exafunction/codeium.vim",
		config = function()
			-- Change '<C-g>' here to any keycode you like.
			vim.keymap.set("i", "<C-y>", function()
				return vim.fn["codeium#Accept"]()
			end, { expr = true, silent = true })

			-- vim.keymap.set("i", "<A-n>", function()
			-- 	return vim.fn["codeium#CycleCompletions"](1)
			-- end, { expr = true, silent = true })

			-- vim.keymap.set("i", "<A-p>", function()
			-- 	return vim.fn["codeium#CycleCompletions"](-1)
			-- end, { expr = true, silent = true })

			-- vim.keymap.set("i", "<A-x>", function()
			-- 	return vim.fn["codeium#Clear"]()
			-- end, { expr = true, silent = true })

			vim.keymap.set("n", "<AS-c>", vim.cmd.CodeiumToggle, { expr = true, silent = true })
		end,
	},
	-- {
	-- 	"github/copilot.vim",
	-- 	config = function()
    --         vim.g.copilot_enabled = false
	-- 		vim.keymap.set("n", "<leader>cp", vim.cmd.Copilot, { silent = true })
	-- 	end,
	-- },
}
