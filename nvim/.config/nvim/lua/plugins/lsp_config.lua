return {

	-- Mason
	{
		"williamboman/mason.nvim",
		event = "VeryLazy",
		config = function()
			require("mason").setup({
				ensure_installed = {
					"clangd",
					"lua_ls",
					"ruff",
					"pyright",
					"marksman",
					"neocmake",

					"cpplint",
					"clang-format",
					"gersemi",
					"marksman",
					"texlab",
					"stylua",
					"luacheck",

					"codelldb",
				},
			})
		end,
	},

	{
		"williamboman/mason-lspconfig.nvim",
		event = "VeryLazy",
		dependencies = {
			"saghen/blink.cmp",
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		config = function()
			require("mason-lspconfig").setup()
			local capabilities = require("blink.cmp").get_lsp_capabilities()
			-- local capabilities = require("cmp_nvim_lsp").default_capabilities()
			capabilities.textDocument.foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			}

			require("mason-lspconfig").setup_handlers({
				function(server_name) -- default handler (optional)
					require("lspconfig")[server_name].setup({})
				end,

				-- ["server"] = function()
				--                 local lspconfig = require("lspconfig")
				--                 lspconfig.server.setup({
				--                 })
				-- end,

				["pyright"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.pyright.setup({
						settings = {
							pyright = {
								-- Using Ruff's import organizer
								disableOrganizeImports = true,
							},
							python = {
								analysis = {
									-- Ignore all files for analysis to exclusively use Ruff for linting
									ignore = { "*" },
								},
							},
						},
					})
				end,
			})
		end,
	},

	-- Lsp config
	{
		"neovim/nvim-lspconfig",
		event = "VeryLazy",
		dependencies = {
			"saghen/blink.cmp",
		},
		config = function()
			local lsp_config = require("lspconfig")
			local capabilities = require("blink.cmp").get_lsp_capabilities()
			-- local capabilities = require("cmp_nvim_lsp").default_capabilities()
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
						vim.diagnostic.open_float()
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
				end,
			})
		end,
	},

	{
		"zeioth/garbage-day.nvim",
		dependencies = "neovim/nvim-lspconfig",
		event = "VeryLazy",
		opts = {
			aggressive_mode = false,
			grace_period = 60 * 10,
		},
	},

	-- nvim-lint and conform
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = {},
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "ruff_format" },
					c = { "clang-format" },
					cmake = { "gersemi" },
				},
				format_on_save = {
					async = false,
					timeout_ms = 500,
					lsp_fallback = true,
				},
			})
		end,
	},

	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")

			lint.linters_by_ft = {
				lua = { "luacheck" },
				python = { "ruff" },
				c = { "cpplint" },
			}

			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				-- vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
				group = lint_augroup,
				callback = function()
					if vim.opt_local.modifiable:get() then
						-- lint.try_lint()
						lint.try_lint(nil, { ignore_errors = true })
					end
				end,
			})
		end,
	},
}
