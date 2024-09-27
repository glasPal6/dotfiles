return {
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",  -- required
            "sindrets/diffview.nvim", -- optional - Diff integration

            -- Only one of these is needed, not both.
            "nvim-telescope/telescope.nvim", -- optional
        },
        config = function()
            require("neogit").setup({
            })
            vim.keymap.set("n", "<leader>gs", ":Neogit<CR>")
            vim.keymap.set("n", "<leader>gl", ":Neogit log<CR>")
            vim.keymap.set("n", "<leader>gb", ":Neogit branch<CR>")
        end,
    },
    {
        "sindrets/diffview.nvim",
        config = function()
            vim.keymap.set("n", "<leader>gd", ":DiffviewOpen<CR>")
            vim.keymap.set("n", "<leader>gh", ":DiffviewFileHistory %<CR>")
        end,
    },
}
