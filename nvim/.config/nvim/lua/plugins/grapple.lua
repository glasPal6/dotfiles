return {

    -- Easily move around files
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
            { "<leader>C", "<cmd>Grapple cycle_tags next<cr>", desc = "Grapple cycle next tag",     silent = true },
            { "<leader>P", "<cmd>Grapple cycle_tags prev<cr>", desc = "Grapple cycle previous tag", silent = true },

            { "<C-a>",     "<cmd>Grapple select index=1<cr>",  desc = "Select first tag",           silent = true },
            { "<C-e>",     "<cmd>Grapple select index=2<cr>",  desc = "Select second tag",          silent = true },
            { "<C-i>",     "<cmd>Grapple select index=3<cr>",  desc = "Select third tag",           silent = true },
            { "<C-h>",     "<cmd>Grapple select index=4<cr>",  desc = "Select fourth tag",          silent = true },
        },
    },
}
