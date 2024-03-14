return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")
		-- local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

		null_ls.setup({
			sources = {
				-- Lua
				null_ls.builtins.formatting.stylua,
				-- Python
				null_ls.builtins.formatting.black,
				null_ls.builtins.formatting.isort,
				-- C/Cpp
				null_ls.builtins.formatting.clang_format,
			},
			-- on_attach = function(client, bufnr)
			-- 	if client.supports_method("textDocument/formatting") then
			-- 		vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			-- 		vim.api.nvim_create_autocmd("BufWritePre", {
			-- 			group = augroup,
			-- 			buffer = bufnr,
			-- 			callback = function()
			--                 vim.lsp.buf.format({ async = false })
			-- 			end,
			-- 		})
			-- 	end
			-- end,
		})

		vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
	end,
}
