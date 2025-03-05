return {

    -- Snippets
    {
        "L3MON4D3/LuaSnip",
        dependencies = {
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
        },
        config = function()
            vim.keymap.set("i", "<S-Up>", "<cmd>lua require'luasnip'.jump(-1)<CR>")
            vim.keymap.set("s", "<S-Up>", "<cmd>lua require'luasnip'.jump(-1)<CR>")
            vim.keymap.set("i", "<S-Down>", "<cmd>lua require'luasnip'.jump(1)<CR>")
            vim.keymap.set("s", "<S-Down>", "<cmd>lua require'luasnip'.jump(1)<CR>")
        end,
    },

    -- Autocomplete
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "neovim/nvim-lspconfig",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-buffer",
            -- "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-nvim-lsp-signature-help",
        },
        config = function()
            local cmp = require("cmp")
            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    -- 	["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    -- 	["<C-f>"] = cmp.mapping.scroll_docs(4),
                    -- 	["<C-Space>"] = cmp.mapping.complete(),
                    -- 	["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm(),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "nvim_lsp_signature_help" },
                }, {
                    -- { name = "buffer" },
                }),
            })

            -- cmp.setup.cmdline({ '/', '?' }, {
            --     mapping = cmp.mapping.preset.cmdline(),
            --     sources = {
            --         { name = 'buffer' }
            --     }
            -- })
            --
            -- cmp.setup.cmdline(':', {
            --     mapping = cmp.mapping.preset.cmdline(),
            --     sources = cmp.config.sources({
            --         { name = 'path' }
            --     }, {
            --         { name = 'cmdline' }
            --     }),
            --     matching = { disallow_symbol_nonprefix_matching = false }
            -- })
        end,
    },
}
