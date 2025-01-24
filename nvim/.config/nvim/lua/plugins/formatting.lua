return {
    {
        "gbprod/nord.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("nord").setup({})
            vim.cmd.colorscheme("nord")
        end,
    },
    {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
            default = {
                embed_image_as_base64 = false,
                prompt_for_file_name = false,
                drag_and_drop = {
                    insert_mode = true,
                },
                use_absolute_path = true,
            },
        },
    },
    {
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
            file_types = { "markdown", "latex" },
            indent = {
                enabled = true,
            },
        },
        ft = { "markdown", "latex" },
    },
}
