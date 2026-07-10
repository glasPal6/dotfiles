return {

	-- Coding objects
	{
		"nvim-treesitter/nvim-treesitter",
		event = "VeryLazy",
		build = ":TSUpdate",
		config = function()
			local ts = require("nvim-treesitter")
			local parsers = { "lua", "vimdoc", "c", "cpp", "python" }
			for _, parser in ipairs(parsers) do
				ts.install(parser)
			end

			-- Deprecated code
			-- ts.setup({
			-- 	auto_install = true,
			-- 	highlight = { enable = true },
			-- 	indent = { enable = true },
			-- })

			local patterns = {}
			for _, parser in ipairs(parsers) do
				local parser_patterns = vim.treesitter.language.get_filetypes(parser)
				for _, pp in pairs(parser_patterns) do
					table.insert(patterns, pp)
				end
			end

			vim.api.nvim_create_autocmd("FileType", {
				pattern = patterns,
				callback = function()
					vim.treesitter.start()
				end,
			})
		end,
	},

	-- tree-sitter-context.lua
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		init = function()
			vim.g.no_plugin_maps = true
		end,
		dependencies = { "nvim-treesitter/nvim-treesitter", branch = "main" },
		config = function()
			require("nvim-treesitter-textobjects").setup({
				select = {
					enable = true,
					lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
				},
				move = {
					set_jumps = true,
				},
			})

			local select = require("nvim-treesitter-textobjects.select")
			vim.keymap.set({ "x", "o" }, "aa", function()
				select.select_textobject("@parameter.outer", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "ia", function()
				select.select_textobject("@parameter.inner", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "af", function()
				select.select_textobject("@function.outer", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "if", function()
				select.select_textobject("@function.inner", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "ac", function()
				select.select_textobject("@class.outer", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "ic", function()
				select.select_textobject("@class.inner", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "ii", function()
				select.select_textobject("@conditional.inner", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "ai", function()
				select.select_textobject("@conditional.outer", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "il", function()
				select.select_textobject("@loop.inner", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "al", function()
				select.select_textobject("@loop.outer", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "at", function()
				select.select_textobject("@comment.outer", "textobjects")
			end)

			local move = require("nvim-treesitter-textobjects.move")
			vim.keymap.set({ "n", "x", "o" }, "]f", function()
				move.goto_next_start("@function.outer", "textobjects")
			end)
			vim.keymap.set({ "n", "x", "o" }, "[f", function()
				move.goto_previous_start("@function.outer", "textobjects")
			end)
		end,
	},
}
