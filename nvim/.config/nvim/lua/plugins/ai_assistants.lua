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
			require("codecompanion").setup({
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
	-- 	"yetone/avante.nvim",
	-- 	event = "VeryLazy",
	-- 	version = false, -- Never set this value to "*"! Never!
	-- 	opts = {
	-- 		provider = "copilot",
	-- 		providers = {
	-- 			-- claude = {
	-- 			-- 	endpoint = "https://api.anthropic.com",
	-- 			-- 	model = "claude-sonnet-4-20250514",
	-- 			-- 	timeout = 30000, -- Timeout in milliseconds
	-- 			-- 	extra_request_body = {
	-- 			-- 		temperature = 0.75,
	-- 			-- 		max_tokens = 20480,
	-- 			-- 	},
	-- 			-- },
	-- 			copilot = {
	-- 				model = "gpt-4.1",
	-- 			},
	-- 		},
	-- 		selection = {
	-- 			enabled = false,
	-- 		},
	-- 		behaviour = {
	-- 			auto_suggestions = false, -- Experimental stage
	-- 			auto_set_highlight_group = true,
	-- 			auto_set_keymaps = true,
	-- 			auto_apply_diff_after_generation = false,
	-- 			support_paste_from_clipboard = false,
	-- 			minimize_diff = true, -- Whether to remove unchanged lines when applying a code block
	-- 			enable_token_counting = true, -- Whether to enable token counting. Default to true.
	-- 			auto_add_current_file = true, -- Whether to automatically add the current file when opening a new chat. Default to true.
	-- 			auto_approve_tool_permissions = false, -- Default: auto-approve all tools (no prompts)
	-- 			-- Examples:
	-- 			-- auto_approve_tool_permissions = false,                -- Show permission prompts for all tools
	-- 			-- auto_approve_tool_permissions = {"bash", "str_replace"}, -- Auto-approve specific tools only
	-- 			---@type "popup" | "inline_buttons"
	-- 			confirmation_ui_style = "inline_buttons",
	-- 			--- Whether to automatically open files and navigate to lines when ACP agent makes edits
	-- 			---@type boolean
	-- 			acp_follow_agent_locations = true,
	-- 		},
	-- 		windows = {
	-- 			width = 40,
	-- 			input = {
	-- 				height = 10,
	-- 			},
	-- 		},
	-- 	},
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim",
	-- 		"MunifTanjim/nui.nvim",
	-- 		"nvim-telescope/telescope.nvim", -- for file_selector provider telescope
	-- 		"stevearc/dressing.nvim", -- for input provider dressing
	-- 		"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
	-- 		"zbirenbaum/copilot.lua", -- for providers='copilot'
	-- 	},
	-- },
}
