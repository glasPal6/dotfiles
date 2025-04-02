return {

    -- Flash - quick movement
    {
        "folke/flash.nvim",
        event = { "VeryLazy" },
        -- stylua: ignore
        keys = {
            { "s",      mode = { "n", "o" },      function() require("flash").jump() end,              { desc = "Flash" } },
            { "<CS-s>", mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        { desc = "Flash Treesitter" } },
            { "r",      mode = "o",               function() require("flash").remote() end,            { desc = "Remote Flash" } },
            { "<CS-r>", mode = { "o", "x" },      function() require("flash").treesitter_search() end, { desc = "Treesitter Search" } },
            { "<C-s>",  mode = { "c" },           function() require("flash").toggle() end,            { desc = "Toggle Flash Search" } },
        },
        opts = {
            modes = {
                char = {
                    enabled = false,
                    -- autohide = true,
                    jump_labels = false,
                },
            },
        },
    },
}
