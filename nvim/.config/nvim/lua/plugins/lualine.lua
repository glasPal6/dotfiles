return {
    "nvim-lualine/lualine.nvim",
    config = function()
        require("lualine").setup({
            options = {
                -- theme = "dracula",
                theme = "nord",
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch", "diff", "diagnostics" },
                lualine_c = {
                    "filename",
                    "grapple",
                },
                lualine_x = {
                    function()
                        return vim.fn["codeium#GetStatusString"]()
                    end,
                },
                lualine_y = { "progress" },
                lualine_z = { "location" },
            },
        })
    end,
}
