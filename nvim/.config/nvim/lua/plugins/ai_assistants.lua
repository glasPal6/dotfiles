return {

	-- For more advanced options
	-- {
	--     "github/copilot.vim",
	-- },

	{
		"olimorris/codecompanion.nvim",
		event = { "VeryLazy" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"MeanderingProgrammer/render-markdown.nvim",
		},
		config = function()
			require("codecompanion").setup({
				adapters = {
					copilot = function()
						return require("codecompanion.adapters").extend("copilot", {
							schema = {
								model = {
									-- default = "gpt-4o",
									-- default = "o1",
									-- default = "claude-3.7-sonnet-thought",
									default = "claude-3.7-sonnet",
									-- default = "claude-3.5-sonnet",
								},
							},
						})
					end,
				},
				strategies = {
					chat = { adapter = "copilot" },
					inline = { adapter = "copilot" },
					agent = { adapter = "copilot" },
				},
			})

			vim.keymap.set({ "n", "v" }, "<C-f>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
			vim.keymap.set(
				{ "n", "v" },
				"<Leader>aa",
				"<cmd>CodeCompanionChat Toggle<cr>",
				{ noremap = true, silent = true }
			)
			vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })

			vim.cmd([[cab cc CodeCompanion]])
		end,
	},

	-- {
	-- 	"yetone/avante.nvim",
	-- 	event = "VeryLazy",
	-- 	version = false, -- Never set this value to "*"! Never!
	-- 	opts = {
	-- 		provider = "copilot",
	-- 		copilot = {
	-- 			-- endpoint = "https://api.githubcopilot.com", -- needs Copilot plugin authentication
	-- 			model = "gemini-2.5.pro",
	-- 			-- model = "gpt-4o",
	-- 			-- model = "o1",
	-- 			-- model = "claude-3.7-sonnet-thought",
	-- 			-- model = "claude-3.7-sonnet",
	-- 			-- model = "claude-3.5-sonnet",
	-- 		},
	-- 		hints = { enabled = false },
	-- 	},
	-- 	-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
	-- 	build = "make",
	-- 	-- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
	-- 	dependencies = {
	-- 		"nvim-treesitter/nvim-treesitter",
	-- 		"stevearc/dressing.nvim",
	-- 		"nvim-lua/plenary.nvim",
	-- 		"MunifTanjim/nui.nvim",
	-- 		--- The below dependencies are optional,
	-- 		"hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
	-- 		"ibhagwan/fzf-lua", -- for file_selector provider fzf
	-- 		"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
	-- 		-- "zbirenbaum/copilot.lua", -- for providers='copilot'
	-- 		{
	-- 			-- support for image pasting
	-- 			"HakonHarnes/img-clip.nvim",
	-- 			event = "VeryLazy",
	-- 			opts = {
	-- 				-- recommended settings
	-- 				default = {
	-- 					embed_image_as_base64 = false,
	-- 					prompt_for_file_name = false,
	-- 					drag_and_drop = {
	-- 						insert_mode = true,
	-- 					},
	-- 					-- required for Windows users
	-- 					use_absolute_path = true,
	-- 				},
	-- 			},
	-- 		},
	-- 		{
	-- 			-- Make sure to set this up properly if you have lazy=true
	-- 			"MeanderingProgrammer/render-markdown.nvim",
	-- 			opts = {
	-- 				file_types = { "markdown", "Avante" },
	-- 			},
	-- 			ft = { "markdown", "Avante" },
	-- 		},
	-- 	},
	-- },
}
