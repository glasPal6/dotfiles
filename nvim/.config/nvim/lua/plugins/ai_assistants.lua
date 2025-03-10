return {

    -- Codium plugin
    {
        "monkoose/neocodeium",
        event = { "VeryLazy" },
        config = function()
            local neocodeium = require("neocodeium")
            neocodeium.setup({
                filetypes = {
                    TelescopePrompt = false,
                    ["dap-repl"] = false,
                },
            })

            vim.keymap.set("n", "<AS-c>", ":NeoCodeium toggle<CR>")
            vim.keymap.set("i", "<A-f>", function()
                neocodeium.accept()
            end)
            vim.keymap.set("i", "<A-w>", function()
                neocodeium.accept_word()
            end)
            vim.keymap.set("i", "<A-m>", function()
                neocodeium.accept_line()
            end)
            vim.keymap.set("i", "<A-s>", function()
                neocodeium.cycle_or_complete()
            end)
            vim.keymap.set("i", "<A-r>", function()
                neocodeium.cycle_or_complete(-1)
            end)
        end,
    },

    -- For more advanced options
    -- {
    --     "olimorris/codecompanion.nvim",
    --     event = { "VeryLazy" },
    --     dependencies = {
    --         "nvim-lua/plenary.nvim",
    --         "nvim-treesitter/nvim-treesitter",
    --     },
    --     config = function()
    --         require("codecompanion").setup({
    --             adapters = {
    --                 deepseek = function()
    --                     return require("codecompanion.adapters").extend("openai_compatible", {
    --                         env = {
    --                             url = "https://api.deepseek.com",
    --                             api_key = "YOUR_API_KEY",
    --                         },
    --                     })
    --                 end,
    --             },
    --             strategies = {
    --                 chat = { adapter = "deepseek", },
    --                 inline = { adapter = "deepseek" },
    --                 agent = { adapter = "deepseek" },
    --             },
    --         })
    --     end,
    --     vim.keymap.set({ "n", "v" }, "<Leader>aa", "<cmd>CodeCompanionChat Toggle<cr>",
    --         { noremap = true, silent = true })
    -- },
}
