return {

	-- Run commands in nvim
	{
		"stevearc/overseer.nvim",
		-- event = "VeryLazy",
		opts = {},
		keys = {
			{ "<leader>et", "<cmd>OverseerToggle<CR>", silent = true },
			{ "<leader>er", "<cmd>OverseerRun<CR>", silent = true },
			{ "<leader>el", "<cmd>OverseerLoadBundle<CR>", silent = true },
			{ "<leader>es", "<cmd>OverseerSaveBundle<CR>", silent = true },
			{ "<leader>ed", "<cmd>OverseerDeleteBundle<CR>", silent = true },
			{
				"<leader>eR",
				function()
					local overseer = require("overseer")
					local tasks = overseer.list_tasks({ recent_first = true })
					if vim.tbl_isempty(tasks) then
						vim.notify("No tasks found", vim.log.levels.WARN)
					else
						overseer.run_action(tasks[1], "restart")
					end
				end,
			},
		},
		config = function()
			require("overseer").setup({
				task_list = { direction = "left" },
				component_aliases = {
					default = {
						{ "display_duration", detail_level = 3 },
						"on_output_summarize",
						"on_exit_set_status",
						"on_complete_notify",
						{ "on_complete_dispose", require_view = { "SUCCESS", "FAILURE" } },
						{
							"on_output_quickfix",
							open = true,
							open_height = 30,
						},
					},
				},
				bundles = {
					autostart_on_load = false,
				},
			})
		end,
	},
}
