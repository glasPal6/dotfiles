return {
    -- Plugin options
    -- Neogit: https://github.com/isakbm/gitgraph.nvim
    -- Git Fugitive: tpope/vim-fugitive
    -- Lazygit: kdheepak/lazygit.nvim

    -- Git conficts: akinsho/git-conflict.nvim
    -- Diff view: sindrets/diffview.nvim

    -- Git Graph: isakbm/gitgraph.nvim
    -- Git Signs: lewis6991/gitsigns.nvim

    -- Cool view of git options
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",

            -- Optional
            "nvim-telescope/telescope.nvim",
            "sindrets/diffview.nvim",
        },
        config = function()
            require("neogit").setup({})
            vim.keymap.set("n", "<leader>gs", ":Neogit<CR>")
            vim.keymap.set("n", "<leader>gl", ":Neogit log<CR>")
            vim.keymap.set("n", "<leader>gb", ":Neogit branch<CR>")
        end,
    },

    -- Can see the histroy of a file
    {
        "sindrets/diffview.nvim",
        lazy = true,
        config = function()
            vim.keymap.set("n", "<leader>gd", ":DiffviewOpen<CR>")
            vim.keymap.set("n", "<leader>gh", ":DiffviewFileHistory %<CR>")
        end,
    },

    -- Show git signs in the project
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup({
                on_attach = function(bufnr)
                    local gitsigns = require("gitsigns")

                    local function map(mode, l, r, opts)
                        opts = opts or {}
                        opts.buffer = bufnr
                        vim.keymap.set(mode, l, r, opts)
                    end

                    -- Navigation
                    map("n", "]c", function()
                        if vim.wo.diff then
                            vim.cmd.normal({ "]c", bang = true })
                        else
                            gitsigns.nav_hunk("next")
                        end
                    end)

                    map("n", "[c", function()
                        if vim.wo.diff then
                            vim.cmd.normal({ "[c", bang = true })
                        else
                            gitsigns.nav_hunk("prev")
                        end
                    end)

                    -- Actions
                    map("n", "<leader>hs", gitsigns.stage_hunk)
                    map("n", "<leader>hr", gitsigns.reset_hunk)
                    map("v", "<leader>hs", function()
                        gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                    end)
                    map("v", "<leader>hr", function()
                        gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                    end)
                    map("n", "<leader>hS", gitsigns.stage_buffer)
                    map("n", "<leader>hu", gitsigns.undo_stage_hunk)
                    map("n", "<leader>hR", gitsigns.reset_buffer)
                    map("n", "<leader>hp", gitsigns.preview_hunk)
                    map("n", "<leader>hb", function()
                        gitsigns.blame_line({ full = true })
                    end)
                    map("n", "<leader>tb", gitsigns.toggle_current_line_blame)
                    map("n", "<leader>hd", gitsigns.diffthis)
                    map("n", "<leader>hD", function()
                        gitsigns.diffthis("~")
                    end)
                    map("n", "<leader>td", gitsigns.toggle_deleted)

                    -- Text object
                    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
                end,
            })
        end,
    },

    -- Git commands
    -- {
    --     "tpope/vim-fugitive",
    --     config = function()
    --         vim.keymap.set("n", "<leader>gs", ":vert Git<CR>")
    --         vim.keymap.set("n", "<leader>gb", ":Git blame<CR>")
    --         vim.keymap.set("n", "<leader>gd", ":Gvdiffsplit<CR>")
    --         vim.keymap.set("n", "<leader>gld", ":vsplit<CR>:GlLog<CR>")
    --         vim.keymap.set("n", "<leader>gll", ":vsplit<CR>:0Gllog<CR>")
    --
    --         local autocmd = vim.api.nvim_create_autocmd
    --         autocmd("BufWinEnter", {
    --             pattern = "*",
    --             callback = function()
    --                 if vim.bo.ft ~= "fugitive" then
    --                     return
    --                 end
    --
    --                 local bufnr = vim.api.nvim_get_current_buf()
    --                 local opts = { buffer = bufnr, remap = false }
    --
    --                 vim.keymap.set("n", "<leader>P", function()
    --                     vim.cmd.Git("push")
    --                 end, opts)
    --
    --                 -- rebase always
    --                 vim.keymap.set("n", "<leader>p", function()
    --                     vim.cmd.Git("pull")
    --                 end, opts)
    --             end,
    --         })
    --     end,
    -- },
}
