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
            vim.keymap.set("n", "<leader>bm", vim.cmd.MarksListAll)
            vim.keymap.set("n", "<leader>bb", vim.cmd.BookmarksListAll)

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
            { "<leader>m",  "<cmd>Grapple toggle<cr>",          desc = "Grapple toggle tag" },
            { "<leader>M",  "<cmd>Grapple toggle_tags<cr>",     desc = "Grapple open tags window" },
            { "<leader>N", "<cmd>Grapple cycle_tags next<cr>", desc = "Grapple cycle next tag" },
            { "<leader>P", "<cmd>Grapple cycle_tags prev<cr>", desc = "Grapple cycle previous tag" },

            { "<C-a>",      "<cmd>Grapple select index=1<cr>",  desc = "Select first tag" },
            { "<C-e>",      "<cmd>Grapple select index=2<cr>",  desc = "Select second tag" },
            { "<C-i>",      "<cmd>Grapple select index=3<cr>",  desc = "Select third tag" },
            { "<C-h>",      "<cmd>Grapple select index=4<cr>",  desc = "Select fourth tag" },
        },
        config = function()
            require("grapple").setup({
                scope_hook = function(window)
                    local Grapple = require("grapple")
                    local ScopeActions = require("grapple.scope_actions")
                    local app = Grapple.app()

                    -- Select
                    window:map("n", "<cr>", function()
                        local entry = window:current_entry()
                        local name = entry.data.name
                        window:perform_close(ScopeActions.open_tags, { name = name })
                    end, { desc = "Open scope" })

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
            })
        end,
    },
}
