return {

	-- {
	-- 	"ajbucci/ipynb.nvim",
	-- 	dependencies = {
	-- 		"nvim-treesitter/nvim-treesitter",
	-- 		"neovim/nvim-lspconfig",
	-- 		"nvim-tree/nvim-web-devicons", -- optional, for language icons
	-- 		-- "folke/snacks.nvim", -- optional, for inline images
	-- 	},
	-- 	opts = {},
	-- },

	{
		"sheng-tse/jupynvim",
		lazy = false, -- must own BufReadCmd for *.ipynb before you open one
		tag = "v0.4.6", -- pin: binary is matched to the release the plugin came from
		build = function(plugin)
			local install = loadfile(plugin.dir .. "/lua/jupynvim/install.lua")()
			install.run(plugin)
		end,
		config = function()
			require("jupynvim").setup({
				log_level = "info",
				image_renderer = "placeholder", -- anchored to text, follows scroll, needed for GIFs
				image_rows = 32,
				image_cols = 96,
			})
		end,
	},
}
