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
        vim.keymap.set("n", "<leader>m", vim.cmd.MarksListAll)
        vim.keymap.set("n", "<leader>b", vim.cmd.BookmarksListAll)

        for i=0,9 do
            vim.keymap.set("n", "<leader>b" .. tostring(i), ":BookmarksList " .. tostring(i) .. "<CR>")
        end
    end,
}
