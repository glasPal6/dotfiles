return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			local builtin = require("telescope.builtin")
            -- vim.keymap.set("n", "<leader>pm", ":Telescope find_files hidden=true<CR>", {})
            vim.keymap.set("n", "<leader>pm", ":Telescope find_files<CR>", {})
			vim.keymap.set("n", "<leader>pg", builtin.live_grep, {})
			vim.keymap.set("n", "<leader>ps", builtin.grep_string, {})
			vim.keymap.set("n", "<leader>pt", builtin.treesitter, {})
            -- vim.keymap.set("n", "<leader>M", builtin.marks, {})
			require("telescope").setup({
				defaults = {
					layout_config = {
						prompt_position = "top",
					},
					prompt_prefix = " ",
					sorting_strategy = "ascending",
					dynamic_preview_title = true,
                    color_devicons = true,
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
}
