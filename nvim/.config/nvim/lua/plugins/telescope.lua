return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<leader>pm", builtin.find_files, {})
			vim.keymap.set("n", "<leader>pg", builtin.live_grep, {})
			vim.keymap.set("n", "<leader>ps", builtin.grep_string, {})
            -- vim.keymap.set("n", "<leader>M", builtin.marks, {})
			require("telescope").setup({
				defaults = {
					layout_config = {
						prompt_position = "top",
					},
					prompt_prefix = " ",
					sorting_strategy = "ascending",
					dynamic_preview_title = true,
				},
			})
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})
			require("telescope").load_extension("ui-select")
		end,
	},
	-- {
	-- 	"nvim-telescope/telescope-file-browser.nvim",
	-- 	dependencies = {
	-- 		"nvim-telescope/telescope.nvim",
	-- 		"nvim-lua/plenary.nvim",
	-- 		"nvim-tree/nvim-web-devicons",
	-- 	},
	-- 	config = function()
	-- 		vim.keymap.set("n", "<leader>pm", ":Telescope file_browser<CR>")
	-- 		require("telescope").setup({
	-- 			extensions = {
	-- 				file_browser = {
	-- 					-- theme = "ivy",
	-- 					hijack_netrw = true,
	-- 					initial_browser = "tree",
	-- 					auto_depth = true,
	-- 					depth = 1,
	-- 				},
	-- 			},
	-- 		})
	-- 		require("telescope").load_extension("file_browser")
	-- 	end,
	-- },
	{
		"stevearc/aerial.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			vim.keymap.set("n", "<leader>pf", ":Telescope aerial<CR>")
            require("aerial").setup()
			require("telescope").setup({
				extensions = {
					aerial = {
						-- Display symbols as <root>.<parent>.<symbol>
						show_nesting = {
							["_"] = false, -- This key will be the default
							json = true, -- You can set the option for specific filetypes
							yaml = true,
						},
					},
				},
			})
		end,
	},
}
