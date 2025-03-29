return {

    -- Mason
    {
        "williamboman/mason.nvim",
        event = "VeryLazy",
        config = function()
            require("mason").setup()
        end,
    },

    {
        "williamboman/mason-lspconfig.nvim",
        event = "VeryLazy",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "williamboman/mason.nvim",
        },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "clangd",
                    -- "codelldb",

                    "lua_ls",

                    "pyright",
                },
            })
            require("mason-lspconfig").setup_handlers({
                function(server_name) -- default handler (optional)
                    local capabilities = require("cmp_nvim_lsp").default_capabilities()
                    capabilities.textDocument.foldingRange = {
                        dynamicRegistration = false,
                        lineFoldingOnly = true,
                    }
                    require("lspconfig")[server_name].setup({})
                end,
            })
        end,
    },

    -- Lsp config
    {
        "neovim/nvim-lspconfig",
        event = "VeryLazy",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local lsp_config = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            capabilities.textDocument.foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
            }

            -- Lsp servers
            -- lsp_config.lua_ls.setup({ capabilities = capabilities })
            -- lsp_config.clangd.setup({ capabilities = capabilities })
            -- lsp_config.pyright.setup({ capabilities = capabilities })
            -- lsp_config.neocmake.setup({ capabilities = capabilities })
            -- lsp_config.marksman.setup({ capabilities = capabilities })
            -- lsp_config.texlab.setup({ capabilities = capabilities })
            lsp_config.mojo.setup({ capabilities = capabilities })

            -- Commands if there is an LSP
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspConfig", {}),
                callback = function(ev)
                    -- Enable completion triggered by <c-x><c-o>
                    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

                    local opts = { buffer = ev.buf }
                    vim.keymap.set("n", "gd", function()
                        vim.lsp.buf.definition()
                    end, opts)
                    vim.keymap.set("n", "K", function()
                        vim.lsp.buf.hover()
                    end, opts)
                    vim.keymap.set("n", "<leader>vws", function()
                        vim.lsp.buf.workspace_symbol()
                    end, opts)
                    vim.keymap.set("n", "<leader>vd", function()
                        vim.diagnostc.open_float()
                    end, opts)
                    vim.keymap.set("n", "]d", function()
                        vim.diagnostic.goto_next()
                    end, opts)
                    vim.keymap.set("n", "[d", function()
                        vim.diagnostic.goto_prev()
                    end, opts)
                    vim.keymap.set("n", "<leader>ca", function()
                        vim.lsp.buf.code_action()
                    end, opts)
                    vim.keymap.set("n", "<leader>vrr", function()
                        vim.lsp.buf.references()
                    end, opts)
                    vim.keymap.set("n", "<leader>vrn", function()
                        vim.lsp.buf.rename()
                    end, opts)
                    vim.keymap.set("i", "<C-h>", function()
                        vim.lsp.buf.signature_help()
                    end, opts)

                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = "UserLspConfig",
                        buffer = ev.buf,
                        callback = function()
                            if vim.lsp.buf.format then
                                vim.lsp.buf.format({
                                    async = false,
                                })
                            end
                        end,
                    })
                end,
            })
        end,
    },

    -- nvim-lint and conform
    {
        "stevearc/conform.nvim",
        event = "VeryLazy",
        opts = {},
        config = function()
            require("conform").setup({
                formatters_by_ft = {
                    lua = { "stylua" },
                    python = { "black", "isort" },
                    c = { "clang-format" },
                    cmake = { "gersemi" },
                },
                format_on_save = {
                    -- These options will be passed to conform.format()
                    timeout_ms = 1000,
                    lsp_format = "fallback",
                },
            })
        end,
    },

    {
        "mfussenegger/nvim-lint",
        event = "VeryLazy",
        config = function()
            require("lint").linters_by_ft = {
                lua = { "luacheck" },
                python = { "pylint" },
                c = { "cpplint" },
            }
        end,
    },
}
