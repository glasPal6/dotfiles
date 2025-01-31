local wezterm = require("wezterm")
local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")

local config = {}
config.default_workspace = "~"
config.keys = {
    {
        key = "f",
        mods = "LEADER",
        action = workspace_switcher.switch_workspace(),
    },
    {
        key = "F",
        mods = "LEADER",
        action = workspace_switcher.switch_to_prev_workspace(),
    }
}
workspace_switcher.apply_to_config(config)
return config
