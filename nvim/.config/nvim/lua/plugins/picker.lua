return {

    -- FZF-Lua
    {
        "ibhagwan/fzf-lua",
        event = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            { "<leader>pm", "<cmd>FzfLua files<CR>",        silent = true },
            { "<leader>pg", "<cmd>FzfLua live_grep<CR>",    silent = true },
            { "<leader>pc", "<cmd>FzfLua git_bcommits<CR>", silent = true },
            { "<leader>pt", "<cmd>FzfLua treesitter<CR>",   silent = true },
        },
        config = function()
            local fzflua = require("fzf-lua")

            fzflua.setup({
                files = {
                    cwd_prompt = false,
                    prompt = " ",
                },
            })

            fzflua.register_ui_select(function(_, items)
                local min_h, max_h = 0.15, 0.70
                local h = (#items + 4) / vim.o.lines
                if h < min_h then
                    h = min_h
                elseif h > max_h then
                    h = max_h
                end
                return { winopts = { height = h, width = 0.60, row = 0.40, relative = "cursor" } }
            end)
        end,
    },
}
