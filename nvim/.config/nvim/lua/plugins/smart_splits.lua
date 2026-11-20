return {
	-- Navigation between nvim splits and Rex panes (alt+shift+arrows; the Rex side is in rex/.config/rex/keybindings.lua)
	{
		"mrjones2014/smart-splits.nvim",
		version = "^3.0.0",
		event = "VeryLazy",
		dependencies = { "rawnly/smart-splits-backend-rex" },
		opts = { mux = { backend = "smart-splits-backend-rex" } },
		keys = {
			{ "<M-S-Left>", function() require("smart-splits").move_cursor_left() end },
			{ "<M-S-Down>", function() require("smart-splits").move_cursor_down() end },
			{ "<M-S-Up>", function() require("smart-splits").move_cursor_up() end },
			{ "<M-S-Right>", function() require("smart-splits").move_cursor_right() end },
		},
	},
}
