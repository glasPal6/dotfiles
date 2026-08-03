return {

	{
		"olimorris/codecompanion.nvim",
		event = { "VeryLazy" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"MeanderingProgrammer/render-markdown.nvim",
		},
		config = function()
			local model_choice = "composer-2.5"
			require("codecompanion").setup({
				ignore_warnings = true,
				adapters = {
					acp = {
						cursor_cli = function()
							return require("codecompanion.adapters").extend("cursor_cli", {
								commands = {
									default = {
										"agent",
										"acp",
										"--model",
										model_choice,
									},
								},
								defaults = {
									session_config_options = {
										model = model_choice,
									},
								},
							})
						end,
					},
				},
				strategies = {
					chat = {
						adapter = {
							name = "cursor_cli",
							model = model_choice,
						},
					},
					cli = {
						adapter = {
							name = "cursor_cli",
							model = model_choice,
						},
					},
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

			-- vim.keymap.set({ "n", "v" }, "<C-f>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
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
