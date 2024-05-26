-- Pull in the wezterm API
local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Unix domains
config.unix_domains = {
    {
        name = "Base_domain",
        -- local_echo_threshold_ms = 50000,
    },
    -- {
    --     name = "Projects",
    --     -- local_echo_threshold_ms = 50000,
    -- },
    -- {
    --     name = "Univeristy",
    --     -- local_echo_threshold_ms = 50000,
    -- },
}
-- config.default_gui_startup_args = { "connect", "Base_domain", }
config.default_workspace = "Base"

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


return config
