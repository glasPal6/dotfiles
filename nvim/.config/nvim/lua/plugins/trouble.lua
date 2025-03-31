return {

    -- LSP diagnostics
    {
        "folke/trouble.nvim",
        event = "VeryLazy",
        opts = {
            modes = {
                symbols = { -- Configure symbols mode
                    win = {
                        type = "split", -- split window
                        relative = "win", -- relative to current window
                        position = "right", -- right side
                        size = 0.3, -- 30% of the window
                    },
                },
            },
        },
        cmd = "Trouble",
        -- stylua: ignore
        keys = {
            { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",                                     silent = true, desc = "Diagnostics (Trouble)", },
            { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",                        silent = true, desc = "Buffer Diagnostics (Trouble)", },
            { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>",                             silent = true, desc = "Symbols (Trouble)", },
            { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right win.size=0.3<cr>", silent = true, desc = "LSP Definitions / references / ... (Trouble)", },
            { "<leader>ct", "<cmd>Trouble qflist toggle<cr>",                                          silent = true, desc = "Quickfix list toggle", },
        },
    },
}
