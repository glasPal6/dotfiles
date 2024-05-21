-- Pull in the wezterm API
local wezterm = require("wezterm")
local config = wezterm.config_builder()

local smart_splits = require("smart_splits")

-- Leader is the same as my old tmux prefix
config.leader = { key = " ", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
    -- splitting
    {
        mods = "LEADER",
        key = "s",
        action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
    },
    {
        mods = "LEADER",
        key = "v",
        action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
    },

    -- Zoom
    {
        mods = "LEADER",
        key = "z",
        action = wezterm.action.TogglePaneZoomState,
    },

    -- rotate panes
    {
        mods = "LEADER",
        key = "Space",
        action = wezterm.action.RotatePanes("Clockwise"),
    },
    -- show the pane selection mode, but have it swap the active and selected panes
    {
        mods = "LEADER",
        key = "0",
        action = wezterm.action.PaneSelect({
            mode = "SwapWithActive",
        }),
    },

    -- Copy/Vim mode
    {
        mods = "LEADER",
        key = "Enter",
        action = wezterm.action.ActivateCopyMode,
    },
}

-- Smart splits
for _, v in ipairs(smart_splits.keys) do
    table.insert(config.keys, v)
end

-- Style and looks
config.font = wezterm.font("MesloLGS NF")
config.font_size = 9
config.color_scheme = "nord"

return config
