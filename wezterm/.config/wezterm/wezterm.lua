-- Pull in the wezterm API
local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Style and looks
require("style")(config)

-- Start up
require("start_up")(wezterm)

-- keybindings
config.disable_default_key_bindings = true
local smart_splits = require("smart_splits")
config.keys = require("keybindings")
config.leader = {
    mods = "CTRL",
    key = "Space",
    timeout_milliseconds = 1000,
}
for _, v in ipairs(smart_splits.keys) do
    table.insert(config.keys, v)
end

-- Unix domains
config.unix_domains = {
    {
        name = "unix",
    },
}
config.default_gui_startup_args = { "connect", "unix" }
config.default_workspace = "Base"

return config
