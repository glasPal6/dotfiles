return {
    {
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
            vim.keymap.set("n", "<leader>bm", vim.cmd.MarksQFListAll)
            vim.keymap.set("n", "<leader>bb", vim.cmd.BookmarksQFListAll)

            -- for i = 0, 9 do
            -- 	vim.keymap.set("n", "<leader>b" .. tostring(i), ":BookmarksList " .. tostring(i) .. "<CR>")
            -- end
        end,
    },
    {
        "cbochs/grapple.nvim",
        dependencies = {
            { "nvim-tree/nvim-web-devicons", lazy = true },
        },
        opts = {
            scope = "git",
        },
        event = { "BufReadPost", "BufNewFile" },
        cmd = "Grapple",
        keys = {
            { "<leader>m", "<cmd>Grapple toggle<cr>",          desc = "Grapple toggle tag",         silent = true },
            { "<leader>M", "<cmd>Grapple toggle_tags<cr>",     desc = "Grapple open tags window",   silent = true },
            { "<leader>N", "<cmd>Grapple cycle_tags next<cr>", desc = "Grapple cycle next tag",     silent = true },
            { "<leader>P", "<cmd>Grapple cycle_tags prev<cr>", desc = "Grapple cycle previous tag", silent = true },

            { "<C-a>",     "<cmd>Grapple select index=1<cr>",  desc = "Select first tag",           silent = true },
            { "<C-e>",     "<cmd>Grapple select index=2<cr>",  desc = "Select second tag",          silent = true },
            { "<C-i>",     "<cmd>Grapple select index=3<cr>",  desc = "Select third tag",           silent = true },
            { "<C-h>",     "<cmd>Grapple select index=4<cr>",  desc = "Select fourth tag",          silent = true },
        },
        config = function()
            require("grapple").setup({
                scope_hook = function(window)
                    local Grapple = require("grapple")
                    local ScopeActions = require("grapple.scope_actions")
                    local TagActions = require("grapple.tag_actions")
                    local app = Grapple.app()

                    -- Select
                    window:map("n", "<cr>", function()
                        local entry = window:current_entry()
                        local name = entry.data.name
                        window:perform_close(ScopeActions.open_tags, { name = name })
                    end, { desc = "Open scope" })

                    -- Select (horizontal split)
                    window:map("n", "<c-x>", function()
                        local cursor = window:cursor()
                        window:perform_close(TagActions.select, { index = cursor[1], command = vim.cmd.split })
                    end, { desc = "Select (split)" })

                    -- Select (vertical split)
                    window:map("n", "<c-v>", function()
                        local cursor = window:cursor()
                        window:perform_close(TagActions.select, { index = cursor[1], command = vim.cmd.vsplit })
                    end, { desc = "Select (vsplit)" })

                    -- Quick select
                    for i, quick in ipairs(app.settings:quick_select()) do
                        window:map("n", string.format("%s", quick), function()
                            local entry, err = window:entry({ index = i })
                            if not entry then
                                ---@diagnostic disable-next-line: param-type-mismatch
                                return vim.notify(err, vim.log.levels.ERROR)
                            end

                            local name = entry.data.name
                            window:perform_close(ScopeActions.open_tags, { name = name })
                        end, { desc = string.format("Quick open %d", i) })
                    end

                    -- Change
                    window:map("n", "<leader>s", function()
                        local entry = window:current_entry()
                        local name = entry.data.name
                        window:perform_close(ScopeActions.change, { name = name })
                    end, { desc = "Change scope" })

                    -- Navigate "up" to loaded scopes
                    window:map("n", "-", function()
                        window:perform_close(ScopeActions.open_loaded)
                    end, { desc = "Go to loaded scopes" })

                    -- Toggle
                    window:map("n", "g.", function()
                        window:perform_retain(ScopeActions.toggle_all)
                    end, { desc = "Toggle show hidden" })

                    -- Help
                    window:map("n", "?", function()
                        local WindowActions = require("grapple.window_actions")
                        window:perform_retain(WindowActions.help)
                    end, { desc = "Help" })
                end,
                tag_hook = function(window)
                    local Grapple = require("grapple")
                    local TagActions = require("grapple.tag_actions")
                    local app = Grapple.app()

                    -- Select
                    window:map("n", "<cr>", function()
                        local cursor = window:cursor()
                        window:perform_close(TagActions.select, { index = cursor[1] })
                    end, { desc = "Select" })

                    -- Select (horizontal split)
                    window:map("n", "<c-x>", function()
                        local cursor = window:cursor()
                        window:perform_close(TagActions.select, { index = cursor[1], command = vim.cmd.split })
                    end, { desc = "Select (split)" })

                    -- Select (vertical split)
                    window:map("n", "<c-v>", function()
                        local cursor = window:cursor()
                        window:perform_close(TagActions.select, { index = cursor[1], command = vim.cmd.vsplit })
                    end, { desc = "Select (vsplit)" })

                    -- Quick select
                    for i, quick in ipairs(app.settings:quick_select()) do
                        window:map("n", string.format("%s", quick), function()
                            window:perform_close(TagActions.select, { index = i })
                        end, { desc = string.format("Quick select %d", i) })
                    end

                    -- Quickfix list
                    window:map("n", "<c-q>", function()
                        window:perform_close(TagActions.quickfix)
                    end, { desc = "Quickfix" })

                    -- Go "up" to scopes
                    window:map("n", "-", function()
                        window:perform_close(TagActions.open_scopes)
                    end, { desc = "Go to scopes" })

                    -- Rename
                    window:map("n", "R", function()
                        local entry = window:current_entry()
                        local path = entry.data.path
                        window:perform_retain(TagActions.rename, { path = path })
                    end, { desc = "Rename" })

                    -- Help
                    window:map("n", "?", function()
                        local WindowActions = require("grapple.window_actions")
                        window:perform_retain(WindowActions.help)
                    end, { desc = "Help" })
                end,
            })
        end,
    },
}
