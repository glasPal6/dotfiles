return {

    -- Better marks experience
    {
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
            vim.keymap.set("n", "<leader>bm", vim.cmd.MarksQFListAll)
            vim.keymap.set("n", "<leader>bb", vim.cmd.BookmarksQFListAll)
        end,
    },

}
