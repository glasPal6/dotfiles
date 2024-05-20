return {
    {
        "christoomey/vim-tmux-navigator",
        cmd = {
            "TmuxNavigateLeft",
            "TmuxNavigateDown",
            "TmuxNavigateUp",
            "TmuxNavigateRight",
            "TmuxNavigatePrevious",
        },
        keys = {
            { "<C-Left>",  "<cmd>TmuxNavigateLeft<cr>" },
            { "<C-Down>",  "<cmd>TmuxNavigateDown<cr>" },
            { "<C-Up>",  "<cmd>TmuxNavigateUp<cr>" },
            { "<C-Right>",  "<cmd>TmuxNavigateRight<cr>" },
            { "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>" },
        },
        config = function()
            vim.g.tmux_navigator_save_on_switch = 1
        end
    },
}
