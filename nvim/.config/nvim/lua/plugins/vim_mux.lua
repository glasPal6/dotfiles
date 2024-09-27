return {
    -- {
    --     "christoomey/vim-tmux-navigator",
    --     cmd = {
    --         "TmuxNavigateLeft",
    --         "TmuxNavigateDown",
    --         "TmuxNavigateUp",
    --         "TmuxNavigateRight",
    --         "TmuxNavigatePrevious",
    --     },
    --     keys = {
    --         { "<C-Left>",  "<cmd>TmuxNavigateLeft<cr>" },
    --         { "<C-Down>",  "<cmd>TmuxNavigateDown<cr>" },
    --         { "<C-Up>",  "<cmd>TmuxNavigateUp<cr>" },
    --         { "<C-Right>",  "<cmd>TmuxNavigateRight<cr>" },
    --         { "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>" },
    --     },
    --     config = function()
    --         vim.g.tmux_navigator_save_on_switch = 1
    --     end
    -- },
    {
        "mrjones2014/smart-splits.nvim",
        config = function()
            require("smart-splits").setup()
            vim.keymap.set("n", "<C-Left>", require("smart-splits").move_cursor_left)
            vim.keymap.set("n", "<C-Down>", require("smart-splits").move_cursor_down)
            vim.keymap.set("n", "<C-Up>", require("smart-splits").move_cursor_up)
            vim.keymap.set("n", "<C-Right>", require("smart-splits").move_cursor_right)
            vim.keymap.set("n", "<C-\\>", require("smart-splits").move_cursor_previous)

            vim.keymap.set('n', '<A-Left>', require('smart-splits').resize_left)
            vim.keymap.set('n', '<A-Down>', require('smart-splits').resize_down)
            vim.keymap.set('n', '<A-Up>', require('smart-splits').resize_up)
            vim.keymap.set('n', '<A-Right>', require('smart-splits').resize_right)

            -- vim.keymap.set('n', '<leader><C-Left>', require('smart-splits').swap_buf_left)
            -- vim.keymap.set('n', '<leader><C-Down>', require('smart-splits').swap_buf_down)
            -- vim.keymap.set('n', '<leader><C-Up>', require('smart-splits').swap_buf_up)
            -- vim.keymap.set('n', '<leader><C-Right>', require('smart-splits').swap_buf_right)
        end,
    },
}
