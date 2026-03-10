return {

	-- For more advanced options
	-- {
	-- 	"github/copilot.vim",
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
			-- local model_choice = "claude-3.5-sonnet"
			local model_choice = "gpt-4.1"
			-- local model_choice = "gpt-5.1"
			-- local model_choice = "gpt-5.2-codex"
			require("codecompanion").setup({
				ignore_warnings = true,
				strategies = {
					chat = {
						adapter = {
							name = "copilot",
							model = model_choice,
						},
					},
					inline = {
						adapter = {
							name = "copilot",
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

			vim.keymap.set({ "n", "v" }, "<C-f>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
			vim.keymap.set(
				{ "n", "v" },
				"<Leader>aa",
				"<cmd>CodeCompanionChat Toggle<cr>",
				{ noremap = true, silent = true }
			)

			vim.cmd([[cab cc CodeCompanion]])
		end,
	},

	-- {
	-- 	{
	-- 		"folke/sidekick.nvim",
	-- 		opts = {
	-- 			-- add any options here
	-- 			cli = {
	-- 				mux = {
	-- 					backend = "zellij",
	-- 					enabled = true,
	-- 				},
	-- 			},
	-- 		},
	-- 		keys = {
	-- 			{
	-- 				"<tab>",
	-- 				function()
	-- 					-- if there is a next edit, jump to it, otherwise apply it if any
	-- 					if not require("sidekick").nes_jump_or_apply() then
	-- 						return "<Tab>" -- fallback to normal tab
	-- 					end
	-- 				end,
	-- 				expr = true,
	-- 				desc = "Goto/Apply Next Edit Suggestion",
	-- 			},
	-- 			{
	-- 				"<c-.>",
	-- 				function()
	-- 					require("sidekick.cli").toggle()
	-- 				end,
	-- 				desc = "Sidekick Toggle",
	-- 				mode = { "n", "t", "i", "x" },
	-- 			},
	-- 			{
	-- 				"<leader>aa",
	-- 				function()
	-- 					require("sidekick.cli").toggle()
	-- 				end,
	-- 				desc = "Sidekick Toggle CLI",
	-- 			},
	-- 			{
	-- 				"<leader>as",
	-- 				function()
	-- 					require("sidekick.cli").select()
	-- 				end,
	-- 				-- Or to select only installed tools:
	-- 				-- require("sidekick.cli").select({ filter = { installed = true } })
	-- 				desc = "Select CLI",
	-- 			},
	-- 			{
	-- 				"<leader>ad",
	-- 				function()
	-- 					require("sidekick.cli").close()
	-- 				end,
	-- 				desc = "Detach a CLI Session",
	-- 			},
	-- 			{
	-- 				"<leader>at",
	-- 				function()
	-- 					require("sidekick.cli").send({ msg = "{this}" })
	-- 				end,
	-- 				mode = { "x", "n" },
	-- 				desc = "Send This",
	-- 			},
	-- 			{
	-- 				"<leader>af",
	-- 				function()
	-- 					require("sidekick.cli").send({ msg = "{file}" })
	-- 				end,
	-- 				desc = "Send File",
	-- 			},
	-- 			{
	-- 				"<leader>av",
	-- 				function()
	-- 					require("sidekick.cli").send({ msg = "{selection}" })
	-- 				end,
	-- 				mode = { "x" },
	-- 				desc = "Send Visual Selection",
	-- 			},
	-- 			{
	-- 				"<leader>ap",
	-- 				function()
	-- 					require("sidekick.cli").prompt()
	-- 				end,
	-- 				mode = { "n", "x" },
	-- 				desc = "Sidekick Select Prompt",
	-- 			},
	-- 			-- Example of a keybinding to open Claude directly
	-- 			{
	-- 				"<leader>ac",
	-- 				function()
	-- 					require("sidekick.cli").toggle({ name = "claude", focus = true })
	-- 				end,
	-- 				desc = "Sidekick Toggle Claude",
	-- 			},
	-- 		},
	-- 	},
	-- },
}
