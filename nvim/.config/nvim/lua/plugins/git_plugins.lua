return {
    -- {
    --     "tpope/vim-fugitive",
    --     config = function()
    --         vim.keymap.set("n", "<leader>gs", ":vert Git<CR><C-w>o");
    --         vim.keymap.set("n", "<leader>gb", ":Git blame<CR>");
    --         vim.keymap.set("n", "<leader>gd", ":Gvdiffsplit<CR>");
    --         vim.keymap.set("n", "<leader>gt", ":vert Git log --graph --decorate --abbrev-commit --oneline <CR>");
    --         vim.keymap.set("n", "<leader>gl", ":vsplit<CR>:0Gllog<CR>");

    --         local autocmd = vim.api.nvim_create_autocmd
    --         autocmd("BufWinEnter", {
    --             pattern = "*",
    --             callback = function()
    --                 if vim.bo.ft ~= "fugitive" then
    --                     return
    --                 end

    --                 local bufnr = vim.api.nvim_get_current_buf()
    --                 local opts = {buffer = bufnr, remap = false}

    --                 vim.keymap.set("n", "<leader>P", function()
    --                     vim.cmd.Git('push')
    --                 end, opts)

    --                 vim.keymap.set("n", "<leader>p", function()
    --                     vim.cmd.Git('pull')
    --                 end, opts)
    --             end,
    --         })
    --     end
    -- },
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
