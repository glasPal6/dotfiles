return {

    -- Navigation between nvim and wezterm
    {
        "mrjones2014/smart-splits.nvim",
        event = "VeryLazy",
        config = function()
            require("smart-splits").setup()
            vim.keymap.set("n", "<C-Left>", require("smart-splits").move_cursor_left)
            vim.keymap.set("n", "<C-Down>", require("smart-splits").move_cursor_down)
            vim.keymap.set("n", "<C-Up>", require("smart-splits").move_cursor_up)
            vim.keymap.set("n", "<C-Right>", require("smart-splits").move_cursor_right)
            vim.keymap.set("n", "<C-\\>", require("smart-splits").move_cursor_previous)

            vim.keymap.set("n", "<A-Left>", require("smart-splits").resize_left)
            vim.keymap.set("n", "<A-Down>", require("smart-splits").resize_down)
            vim.keymap.set("n", "<A-Up>", require("smart-splits").resize_up)
            vim.keymap.set("n", "<A-Right>", require("smart-splits").resize_right)
        end,
    },
}
