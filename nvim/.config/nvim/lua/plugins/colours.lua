return {
    --"folke/tokyonight.nvim",
    "nordtheme/vim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
        -- vim.cmd[[colorscheme tokyonight]]
        vim.cmd[[colorscheme nord]]
    end
}
