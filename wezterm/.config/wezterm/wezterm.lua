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
    -- {
    --     name = "Base_domain",
    --     -- local_echo_threshold_ms = 50000,
    -- },
    {
        name = "persistent",
        -- connect_automatically = true,
        local_echo_threshold_ms = 50000,
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

-- Plugins
local smart_splits = require("plugins.smart_splits")
config.keys = merge_all(config.keys, smart_splits.keys)

local resurrect = require("plugins.resurrect")
config.keys = merge_all(config.keys, resurrect.keys)

local sessionizer = require("plugins.sessionizer")
config.keys = merge_all(config.keys, sessionizer.keys)

return config
