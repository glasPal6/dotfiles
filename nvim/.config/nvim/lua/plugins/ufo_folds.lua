return {

    -- Code folds
    {
        "kevinhwang91/nvim-ufo",
        event = "VeryLazy",
        dependencies = {
            "kevinhwang91/promise-async",
        },
        config = function()
            local ufo = require("ufo")

            -- UFO uses nvim-lsp
            ufo.setup()

            -- UFO uses treesitter
            -- ufo.setup({
            -- 	provider_selector = function(bufnr, filetype, buftype)
            -- 		return { "treesitter", "indent" }
            -- 	end,
            -- })

            vim.keymap.set("n", "zR", require("ufo").openAllFolds)
            vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
        end,
    },
}
