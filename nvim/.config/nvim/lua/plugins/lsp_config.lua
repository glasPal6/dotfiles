return {

	-- Mason
	{
		"mason-org/mason.nvim",
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
		"mason-org/mason-lspconfig.nvim",
		event = "VeryLazy",
		dependencies = {
			"saghen/blink.cmp",
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		config = function()
			require("mason-lspconfig").setup({})
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
			-- local lsp_config = require("lspconfig")

			-- Add capabilities
			local capabilities = require("blink.cmp").get_lsp_capabilities()
			capabilities.textDocument.foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			}
			vim.lsp.config("*", {
				capabilities = capabilities,
			})

			-- Lsp servers
			vim.lsp.config("mojo", {
				capabilities = capabilities,
			})
			vim.lsp.config("pyright", {
				capabilities = capabilities,
				settings = {
					pyright = {
						disableOrganizeImports = true,
					},
					python = {
						analysis = {
							ignore = { "*" },
						},
					},
				},
			})

			vim.diagnostic.config({
				virtual_text = true,
				-- virtual_line = true,
				float = {
					border = "rounded",
					source = true,
				},
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "󰅚 ",
						[vim.diagnostic.severity.WARN] = "󰀪 ",
						[vim.diagnostic.severity.INFO] = "󰋽 ",
						[vim.diagnostic.severity.HINT] = "󰌶 ",
					},
					numhl = {
						[vim.diagnostic.severity.ERROR] = "ErrorMsg",
						[vim.diagnostic.severity.WARN] = "WarningMsg",
					},
				},
			})

			-- Commands if there is an LSP
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					-- -- Enable completion triggered by <c-x><c-o>
					-- vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

					local opts = { buffer = ev.buf }

					vim.keymap.set("n", "gd", function()
						vim.lsp.buf.definition()
					end, opts)
					vim.keymap.set("n", "<leader>ca", function()
						vim.lsp.buf.code_action()
					end, opts)
					-- vim.keymap.set("n", "<leader>vrr", function()
					-- 	vim.lsp.buf.references()
					-- end, opts)
					-- vim.keymap.set("n", "<leader>vrn", function()
					-- 	vim.lsp.buf.rename()
					-- end, opts)
				end,
			})
		end,
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
				-- formatters = {
				-- 	clang_format = {
				-- 		prepend_args = {
				-- 			"--style={BasedOnStyle: Google, IndentWidth: 4, BreakBeforeBraces: Attach}",
				-- 		},
				-- 	},
				-- },
				format_on_save = {
					async = false,
					timeout_ms = 500,
					lsp_fallback = true,
				},
			})
		end,
	},

	-- {
	-- 	"mfussenegger/nvim-lint",
	-- 	event = { "BufReadPre", "BufNewFile" },
	-- 	config = function()
	-- 		local lint = require("lint")
	--
	-- 		lint.linters_by_ft = {
	-- 			-- lua = { "luacheck" },
	-- 			python = { "ruff" },
	-- 			-- c = { "cpplint" },
	-- 		}
	--
	-- 		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
	-- 		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
	-- 			-- vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
	-- 			group = lint_augroup,
	-- 			callback = function()
	-- 				if vim.opt_local.modifiable:get() then
	-- 					-- lint.try_lint()
	-- 					lint.try_lint(nil, { ignore_errors = true })
	-- 				end
	-- 			end,
	-- 		})
	-- 	end,
	-- },
}
