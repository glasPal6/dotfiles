return {

    -- Easily embed images into the file
    {
        "HakonHarnes/img-clip.nvim",
        lazy = true,
        -- event = "VeryLazy",
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

    -- Render markdown in a pretty format
    {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown" },
        -- ft = { "markdown", "latex", "tex" },
        opts = {
            file_types = { "markdown" },
            -- file_types = { "markdown", "latex", "tex" },
            indent = {
                enabled = true,
            },
        },
    },
}
