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
									-- default = "claude-sonnet-4",
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
				display = {
					action_palette = {
						width = 95,
						height = 10,
						prompt = "Prompt ", -- Prompt used for interactive LLM calls
						provider = "default", -- Can be "default", "telescope", "fzf_lua", "mini_pick" or "snacks". If not specified, the plugin will autodetect installed providers.
						opts = {
							show_default_actions = true, -- Show the default actions in the action palette?
							show_default_prompt_library = true, -- Show the default prompt library in the action palette?
						},
					},
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
}
