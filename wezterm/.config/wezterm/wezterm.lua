-- Pull in the wezterm API
local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Unix domains
config.unix_domains = {
    -- {
    --     name = "Base_domain",
    --     -- local_echo_threshold_ms = 50000,
    -- },
    {
        name = "Projects",
        -- connect_automatically = true,
        -- local_echo_threshold_ms = 50000,
    },
    {
        name = "Univeristy",
        -- connect_automatically = true,
        -- local_echo_threshold_ms = 50000,
    },
}
-- config.default_gui_startup_args = { "connect", "Base_domain", }
config.default_workspace = "Base"

-- Style and looks
require("style")(config)

-- Start up
require("start_up")(wezterm)

-- keybindings
config.disable_default_key_bindings = true
config.leader = {
    mods = "CTRL",
    key = "Space",
    timeout_milliseconds = 1000,
}

config.keys = require("keybindings")

local smart_splits = require("smart_splits")
for _, v in ipairs(smart_splits.keys) do
    table.insert(config.keys, v)
end


return config
