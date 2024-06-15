return {
    {
        "monkoose/neocodeium",
        event = "VeryLazy",
        config = function()
            local neocodeium = require("neocodeium")
            neocodeium.setup()
            vim.keymap.set("n", "<AS-c>", ":NeoCodeium toggle<CR>")
            vim.keymap.set("i", "<A-f>", function() neocodeium.accept() end)
            vim.keymap.set("i", "<A-w>", function() neocodeium.accept_word() end)
            vim.keymap.set("i", "<A-m>", function() neocodeium.accept_line() end)
            vim.keymap.set("i", "<A-s>", function() neocodeium.cycle_or_complete() end)
            vim.keymap.set("i", "<A-r>", function() neocodeium.cycle_or_complete(-1) end)
        end,
    }
	-- {
	-- 	"Exafunction/codeium.vim",
	-- 	config = function()
    --         vim.g.codeium_enabled = false
    --         vim.g.codeium_disable_bindings = true

	-- 		-- Change '<C-g>' here to any keycode you like.
	-- 		vim.keymap.set("i", "<C-y>", function()
	-- 			return vim.fn["codeium#Accept"]()
	-- 		end, { expr = true, silent = true })

	-- 		-- vim.keymap.set("i", "<A-n>", function()
	-- 		-- 	return vim.fn["codeium#CycleCompletions"](1)
	-- 		-- end, { expr = true, silent = true })

	-- 		-- vim.keymap.set("i", "<A-p>", function()
	-- 		-- 	return vim.fn["codeium#CycleCompletions"](-1)
	-- 		-- end, { expr = true, silent = true })

	-- 		-- vim.keymap.set("i", "<A-x>", function()
	-- 		-- 	return vim.fn["codeium#Clear"]()
	-- 		-- end, { expr = true, silent = true })

	-- 		vim.keymap.set("n", "<AS-c>", vim.cmd.CodeiumToggle, { expr = true, silent = true })
	-- 	end,
	-- },
	-- {
	-- 	"github/copilot.vim",
	-- 	config = function()
    --         vim.g.copilot_enabled = false
	-- 		vim.keymap.set("n", "<leader>cp", vim.cmd.Copilot, { silent = true })
	-- 	end,
	-- },
}
