return {
    "Exafunction/codeium.vim",
    config = function()
        -- Change '<C-g>' here to any keycode you like.
        vim.keymap.set("i", "<A-a>", function()
            return vim.fn["codeium#Accept"]()
        end, { expr = true, silent = true })

        vim.keymap.set("i", "<A-n>", function()
            return vim.fn["codeium#CycleCompletions"](1)
        end, { expr = true, silent = true })

        vim.keymap.set("i", "<A-p>", function()
            return vim.fn["codeium#CycleCompletions"](-1)
        end, { expr = true, silent = true })

        vim.keymap.set("i", "<A-x>", function()
            return vim.fn["codeium#Clear"]()
        end, { expr = true, silent = true })

        vim.keymap.set("n", "<AS-c>", vim.cmd.CodeiumToggle, { expr = true, silent = true })
        vim.g.codeium_disable_bindings = 1
    end,
}
