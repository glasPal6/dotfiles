return {
    -- {
    --     "chentoast/marks.nvim",
    --     config = function()
    --         require("marks").setup({
    --             refresh_interval = 250,
    --             sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
    --             bookmark_0 = {
    --                 sign = "⚑",
    --                 virt_text = "",
    --                 annotate = true,
    --             },
    --             mappings = {},
    --         })
    --         vim.keymap.set("n", "<leader>m", vim.cmd.MarksListAll)
    --         vim.keymap.set("n", "<leader>b", vim.cmd.BookmarksListAll)
    --     end,
    -- },
    -- {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function ()
        local harpoon = require("harpoon")
        harpoon.setup()

        vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
        vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

        vim.keymap.set("n", "<C-r>", function() harpoon:list():select(1) end)
        vim.keymap.set("n", "<C-s>", function() harpoon:list():select(2) end)
        vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end)
        vim.keymap.set("n", "<C-t>", function() harpoon:list():select(4) end)

        -- Toggle previous & next buffers stored within Harpoon list
        vim.keymap.set("n", "<leader>hp", function() harpoon:list():prev() end)
        vim.keymap.set("n", "<leader>hn", function() harpoon:list():next() end)
    end
    -- },
}
