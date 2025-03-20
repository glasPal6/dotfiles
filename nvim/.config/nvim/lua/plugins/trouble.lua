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
        keys = {
            {
                "<leader>xx",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)",
            },
            {
                "<leader>cs",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "Symbols (Trouble)",
            },
            {
                "<leader>cl",
                "<cmd>Trouble lsp toggle focus=false win.position=right win.size=0.3<cr>",
                desc = "LSP Definitions / references / ... (Trouble)",
            },
            {
                "<leader>ct",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Quickfix list toggle",
            },
        },
    },
}
