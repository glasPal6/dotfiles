return {
    "tpope/vim-fugitive",
    config = function()
        vim.keymap.set("n", "<leader>gs", ":vert Git<CR>");
        vim.keymap.set("n", "<leader>gb", ":Git blame<CR>");
        vim.keymap.set("n", "<leader>gd", ":Gvdiffsplit<CR>");

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
}
