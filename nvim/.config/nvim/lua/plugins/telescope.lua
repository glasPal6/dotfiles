return {

    -- Base telescope option
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.5",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            local builtin = require("telescope.builtin")
            require("telescope").setup({
                defaults = {
                    layout_config = {
                        prompt_position = "top",
                    },
                    prompt_prefix = " ",
                    sorting_strategy = "ascending",
                    dynamic_preview_title = true,
                    color_devicons = true,
                },
            })

            vim.keymap.set("n", "<leader>pm", ":Telescope find_files<CR>", {})
            vim.keymap.set("n", "<leader>pg", builtin.live_grep, {})
            vim.keymap.set("n", "<leader>ps", builtin.grep_string, {})
            vim.keymap.set("n", "<leader>pt", builtin.treesitter, {})
        end,
    },

    -- For other options
    {
        "nvim-telescope/telescope-ui-select.nvim",
        config = function()
            require("telescope").setup({
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown({}),
                    },
                },
            })
            require("telescope").load_extension("ui-select")
        end,
    },

}
