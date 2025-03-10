return {
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = {
            "williamboman/mason.nvim",
        },
        event = { "VeryLazy" },
        opts = {
            handlers = {},
        },
    },

    -- C Debugger
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
            "jay-babu/mason-nvim-dap.nvim",
        },
        -- event = { "VeryLazy" },
        keys = {
            {
                "<leader>dc",
                function()
                    require("dap").continue()
                end,
            },
            {
                "<leader>dn",
                function()
                    require("dap").step_over()
                end,
            },
            {
                "<leader>di",
                function()
                    require("dap").step_into()
                end,
            },
            {
                "<leader>do",
                function()
                    require("dap").step_out()
                end,
            },
            {
                "<leader>dt",
                function()
                    require("dap").toggle_breakpoint()
                end,
            },
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
        end,
    },
}
