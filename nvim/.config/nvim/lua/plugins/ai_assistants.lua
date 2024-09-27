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
    -- 	"github/copilot.vim",
    -- 	config = function()
    --         vim.g.copilot_enabled = false
    -- 		vim.keymap.set("n", "<leader>cp", vim.cmd.Copilot, { silent = true })
    -- 	end,
    -- },
}
