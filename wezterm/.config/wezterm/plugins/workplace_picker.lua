local wezterm = require("wezterm")
local workspace_picker = wezterm.plugin.require("https://github.com/isseii10/workspace-picker.wezterm")

local config = wezterm.config_builder()

workspace_picker.setup({
	-- Path to zoxide executable
	zoxide_path = "/opt/homebrew/bin/zoxide",

	-- Custom colors (Tokyo Night theme)
	colors = {
		workspace_prefix = "#9ece6a", -- Green for workspace label
		zoxide_prefix = "#f7768e", -- Red for zoxide label
		current_indicator = "#9ece6a", -- Green for current workspace
		text = "#c8d0e0", -- Light gray for text
		path = "#565f89", -- Dark gray for paths
	},

	-- Custom labels
	labels = {
		workspace = "[Workspace]", -- Label for workspace entries
		zoxide = "[Zoxide]", -- Label for zoxide entries
		current = "<- current", -- Indicator for current workspace
	},

	-- Custom keybindings (set to nil to disable)
	keybinds = {
		show_picker = { mods = "LEADER", key = "f" },
		create_workspace = { mods = "LEADER", key = "F" },
		rename_workspace = { mods = "LEADER", key = "R" },
	},
})

-- Apply default keybindings
workspace_picker.apply_to_config(config)

return config

-- local wezterm = require("wezterm") ---@type Wezterm
-- local ws = wezterm.plugin.require("https://github.com/yriveiro/ws.wez")
--
-- local config = wezterm.config_builder() ---@type Config
--
-- ws.apply_to_config(config, {
-- 	zoxide_path = "/opt/homebrew/bin/zoxide",
-- 	restore_on_gui_startup = true,
-- 	activate_keytable = { mods = "LEADER", key = "f" },
-- 	colors = {
-- 		action_prefix = "#7dcfff",
-- 		workspace_prefix = "#a6e3a1",
-- 		zoxide_prefix = "#f38ba8",
-- 		current_indicator = "#a6e3a1",
-- 		pane_count = "#ffb86c",
-- 		text = "#cdd6f4",
-- 		path = "#6c7086",
-- 		separator = "#6c7086",
-- 	},
-- 	labels = {
-- 		workspace = "",
-- 		zoxide = "",
-- 		current = "",
-- 	},
-- 	style = {
-- 		action = "seti_config",
-- 		current = "cod_rocket",
-- 		pane_count = "cod_library",
-- 		workspace = "md_television_guide",
-- 		zoxide = "oct_file_directory_fill",
-- 	},
-- })
--
-- return config
