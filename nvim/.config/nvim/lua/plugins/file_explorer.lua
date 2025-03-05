return {

    -- Neo tree
    -- {
    --     "nvim-neo-tree/neo-tree.nvim",
    --     -- branch = "v3.x",
    --     lazy = false,
    --     dependencies = {
    --         "nvim-lua/plenary.nvim",
    --         "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    --         "MunifTanjim/nui.nvim",
    --         {
    --             "s1n7ax/nvim-window-picker", -- for open_with_window_picker keymaps
    --             version = "2.*",
    --             config = function()
    --                 require("window-picker").setup({
    --                     filter_rules = {
    --                         include_current_win = false,
    --                         autoselect_one = true,
    --                         -- filter using buffer options
    --                         bo = {
    --                             -- if the file type is one of following, the window will be ignored
    --                             filetype = { "neo-tree", "neo-tree-popup", "notify" },
    --                             -- if the buffer type is one of following, the window will be ignored
    --                             buftype = { "terminal", "quickfix" },
    --                         },
    --                     },
    --                 })
    --             end,
    --         },
    --     },
    --     config = function()
    --         local renderer = require("neo-tree.ui.renderer")
    --
    --         require("neo-tree").setup({
    --             window = {
    --                 position = "current",
    --                 mappings = {
    --                     ["e"] = "open_filesystem",
    --                     ["b"] = "open_buffers",
    --                     ["g"] = "open_git",
    --                 },
    --             },
    --             filesystem = {
    --                 window = {
    --                     mappings = {
    --                         ["X"] = "system_open",
    --                     },
    --                 },
    --                 filtered_items = {
    --                     visible = true,
    --                     hide_dotfiles = false,
    --                     hide_gitignored = false,
    --                 },
    --             },
    --             commands = {
    --                 open_filesystem = function()
    --                     vim.api.nvim_exec("Neotree focus filesystem current", true)
    --                 end,
    --                 open_buffers = function()
    --                     vim.api.nvim_exec("Neotree focus buffers current", true)
    --                 end,
    --                 open_git = function()
    --                     vim.api.nvim_exec("Neotree focus git_status current", true)
    --                 end,
    --                 system_open = function(state)
    --                     local node = state.tree:get_node()
    --                     local path = node:get_id()
    --                     vim.fn.jobstart({ "xdg-open", path }, { detach = true })
    --                 end,
    --             },
    --         })
    --
    --         vim.keymap.set("n", "-", ":Neotree<CR>")
    --     end,
    -- },

    -- Oil
    {
        "stevearc/oil.nvim",
        opts = {},
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("oil").setup({
                default_file_explorer = true,
                -- Id is automatically added at the beginning, and name at the end
                -- See :help oil-columns
                columns = {
                    "icon",
                    "permissions",
                    "size",
                    "mtime",
                },
                skip_confirm_for_simple_edits = true,
                view_options = {
                    -- Show files and directories that start with "."
                    show_hidden = true,
                },
                constrain_cursor = "name",
            })
            vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
            vim.api.nvim_create_autocmd("User", {
                pattern = "OilEnter",
                callback = vim.schedule_wrap(function(args)
                    local oil = require("oil")
                    if vim.api.nvim_get_current_buf() == args.data.buf and oil.get_cursor_entry() then
                        oil.open_preview()
                    end
                end),
            })
        end,
    },
}
