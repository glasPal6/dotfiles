return {

    -- Oil
    {
        "stevearc/oil.nvim",
        opts = {},
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("oil").setup({
                default_file_explorer = true,
                delete_to_trash = true,
                columns = {
                    "icon",
                    "permissions",
                    "size",
                    "mtime",
                },
                skip_confirm_for_simple_edits = true,
                view_options = {
                    show_hidden = true,
                },
                constrain_cursor = "name",
            })
            vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

            -- -- Automatically open preview
            -- vim.api.nvim_create_autocmd("User", {
            --     pattern = "OilEnter",
            --     callback = vim.schedule_wrap(function(args)
            --         local oil = require("oil")
            --         if vim.api.nvim_get_current_buf() == args.data.buf and oil.get_cursor_entry() then
            --             oil.open_preview()
            --         end
            --     end),
            -- })
        end,
    },
}
