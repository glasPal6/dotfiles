return {
    {
        "jay-babu/mason-nvim-dap.nvim",
        event = "VeryLazy",
        dependencies = {
            "williamboman/mason.nvim",
            "mfussenegger/nvim-dap",
        },
        opts = {
            handlers = {},
        },
    },

    -- C Debugger
    {
        "mfussenegger/nvim-dap",
        event = "VeryLazy",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")
            require("dapui").setup()

            dap.listeners.before.attach.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                dapui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                dapui.close()
            end

            vim.keymap.set("n", "<leader>dc", function()
                dap.continue()
            end)
            vim.keymap.set("n", "<leader>dn", function()
                dap.step_over()
            end)
            vim.keymap.set("n", "<leader>di", function()
                dap.step_into()
            end)
            vim.keymap.set("n", "<leader>do", function()
                dap.step_out()
            end)
            vim.keymap.set("n", "<leader>dt", function()
                dap.toggle_breakpoint()
            end)
        end,
    },
}
