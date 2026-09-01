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
			local model_choice = "haiku"
			require("codecompanion").setup({
				adapters = {
					acp = {
						claude_code = function()
							return require("codecompanion.adapters").extend("claude_code", {
								env = {
									CLAUDE_CODE_OAUTH_TOKEN = os.getenv("CLAUDE_CODE_OAUTH_TOKEN"),
								},
							})
						end,
					},
				},

				interactions = {
					chat = {
						adapter = {
							name = "claude_code",
							model = model_choice,
						},
					},
					cli = {
						agent = "claude_code",
						agents = {
							claude_code = {
								cmd = "claude",
								args = {},
								description = "Claude Code CLI",
								provider = "terminal",
							},
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
							show_preset_actions = true, -- Show the default actions in the action palette?
							show_preset_prompts = true, -- Show the default prompt library in the action palette?
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
