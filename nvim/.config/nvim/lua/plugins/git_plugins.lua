return {
    {
        "tpope/vim-fugitive",
        config = function()
            vim.keymap.set("n", "<leader>gs", ":vert Git<CR>");
            vim.keymap.set("n", "<leader>gb", ":Git blame<CR>");
            vim.keymap.set("n", "<leader>gd", ":Gvdiffsplit<CR>");
            vim.keymap.set("n", "<leader>gld", ":vsplit<CR>:GlLog<CR>");
            vim.keymap.set("n", "<leader>gll", ":vsplit<CR>:0Gllog<CR>");

            local autocmd = vim.api.nvim_create_autocmd
            autocmd("BufWinEnter", {
                pattern = "*",
                callback = function()
                    if vim.bo.ft ~= "fugitive" then
                        return
                    end

                    local bufnr = vim.api.nvim_get_current_buf()
                    local opts = {buffer = bufnr, remap = false}

                    vim.keymap.set("n", "<leader>p", function()
                        vim.cmd.Git('push')
                    end, opts)

                    -- rebase always
                    vim.keymap.set("n", "<leader>P", function()
                        vim.cmd.Git('pull')
                    end, opts)
                end,
            })
        end
    },
    {
        "ThePrimeagen/git-worktree.nvim",
        config = function ()
			require("git-worktree").setup()
            require("telescope").load_extension("git_worktree")

            vim.keymap.set("n", "<leader>gww", ":lua require('telescope').extensions.git_worktree.git_worktrees()<CR>")
            vim.keymap.set("n", "<leader>gwc", ":lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>")
        end
    }
}
