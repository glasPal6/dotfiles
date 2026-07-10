return {

	-- Easily embed images into the file
	{
		"HakonHarnes/img-clip.nvim",
		lazy = true,
		-- event = "VeryLazy",
		opts = {
			default = {
				embed_image_as_base64 = false,
				prompt_for_file_name = false,
				drag_and_drop = {
					insert_mode = true,
				},
				use_absolute_path = true,
			},
		},
	},

	-- {
	-- 	"toppair/peek.nvim",
	-- 	event = { "VeryLazy" },
	-- 	build = "deno task --quiet build:fast",
	-- 	config = function()
	-- 		require("peek").setup()
	-- 		vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
	-- 		vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
	-- 	end,
	-- },

	{
		"MeanderingProgrammer/render-markdown.nvim",
		event = "VeryLazy",
		ft = { "markdown" },
		opts = {
			file_types = { "markdown" },
			anti_conceal = {
				enabled = false,
			},
		},
	},
}
