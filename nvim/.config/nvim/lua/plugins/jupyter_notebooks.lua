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
				image_renderer = "placeholder",
				-- image_renderer = "kitty",
				image_rows = 32,
				image_cols = 96,
			})

			-- local ok, image = pcall(requre, "jupynvim.notebook.image")
			-- if not ok or type(image.supported) ~= "function" then
			-- 	vim.notify(
			-- 		"jupynvim: image.supported() not found - patch in config needs updating",
			-- 		vim.log.levels.WARN
			-- 	)
			-- end

			local image = require("jupynvim.notebook.image")
			local supported = image.supported
			image.supported = function()
				return supported() or (vim.env.TERM_PROGRAM or ""):lower():find("rex") ~= nil
			end
		end,
	},
}
