-- Pull in the wezterm API
local wezterm = require("wezterm")
local config = wezterm.config_builder()

local function merge_all(base, overrides)
	local ret = base or {}
	local second = overrides or {}
	for _, v in pairs(second) do
		table.insert(ret, v)
	end
	return ret
end

-- Unix domains
config.unix_domains = {
	{
		name = "persistent",
		-- connect_automatically = true,
		local_echo_threshold_ms = 50000,
	},
}

config.default_workspace = "Base"
config.switch_to_last_active_tab_when_closing_tab = true
config.prefer_to_spawn_tabs = true
config.window_close_confirmation = "NeverPrompt"

-- config.default_prog = { "zsh", "-c", "nvim ." }

-- Path update
config.set_environment_variables = {
	PATH = "/opt/homebrew/bin:" .. os.getenv("PATH"),
}

-- Style and looks
require("style")(config)

-- Start up
-- require("start_up")(wezterm)
require("start_up")

-- keybindings
config.disable_default_key_bindings = true
config.leader = {
	mods = "CTRL",
	key = "Space",
	timeout_milliseconds = 1000,
}

config.keys = require("keybindings")

-- Plugins
local smart_splits = require("plugins.smart_splits")
config.keys = merge_all(config.keys, smart_splits.keys)

local workspace_picker = require("plugins.workplace_picker")
config.keys = merge_all(config.keys, workspace_picker.keys)

return config
