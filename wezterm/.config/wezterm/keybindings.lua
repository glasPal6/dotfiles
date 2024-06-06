local wezterm = require("wezterm")

local configKeys = {
    -- Terminal
    {
        mods = "",
        key = "F11",
        action = wezterm.action.ToggleFullScreen,
    },
    {
        mods = "LEADER|CTRL",
        key = "Q",
        action = wezterm.action.QuitApplication,
    },

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

    -- Tab navigator
    {
        mods = "LEADER",
        key = "t",
        action = wezterm.action.ShowTabNavigator,
    },
    {
        mods = "LEADER",
        key = "T",
        action = wezterm.action.SpawnTab("CurrentPaneDomain"),
    },
    {
        mods = "LEADER|CTRL",
        key = "T",
        action = wezterm.action.PromptInputLine({
            description = wezterm.format({
                { Attribute = { Intensity = "Bold" } },
                { Foreground = { AnsiColor = "Fuchsia" } },
                { Text = "Enter new current for tab" },
            }),
            action = wezterm.action_callback(function(window, _, line)
                if line then
                    window:active_tab():set_title(line)
                end
            end),
        }),
    },
    {
        mods = "LEADER",
        key = "n",
        action = wezterm.action.ActivateTabRelative(1),
    },
    {
        mods = "LEADER",
        key = "p",
        action = wezterm.action.ActivateTabRelative(-1),
    },

    {
        mods = "LEADER",
        key = "m",
        action = wezterm.action.SpawnCommandInNewTab{ args = { 'btop' }},
    },
    {
        mods = "LEADER",
        key = "g",
        action = wezterm.action.SpawnCommandInNewTab{ args = { 'lazygit' }},
    },
    {
        mods = "LEADER",
        key = "c",
        action = wezterm.action.SpawnCommandInNewTab{ args = { 'lazydocker' }},
    },

    -- Workspace navigator
    {
        mods = "LEADER",
        key = "w",
        action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }),
    },
    {
        mods = "LEADER",
        key = "W",
        action = wezterm.action.PromptInputLine({
            description = wezterm.format({
                { Attribute = { Intensity = "Bold" } },
                { Foreground = { AnsiColor = "Fuchsia" } },
                { Text = "Enter name for new workspace" },
            }),
            action = wezterm.action_callback(function(window, pane, line)
                if line then
                    window:perform_action(
                        wezterm.action.SwitchToWorkspace({
                            name = line,
                        }),
                        pane
                    )
                end
            end),
        }),
    },

    -- Domain navigator
    {
        mods = "LEADER",
        key = "d",
        action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|DOMAINS" }),
    },

    -- General settings
    {
        mods = "LEADER",
        key = "l",
        -- action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY" }),
        action = wezterm.action.ShowLauncher,
    },
    {
        mods = "CTRL|SHIFT",
        key = "v",
        action = wezterm.action.PasteFrom("Clipboard"),
    },
    {
        mods = "CTRL|SHIFT",
        key = "c",
        action = wezterm.action.CopyTo("Clipboard"),
    },
}

for i = 1, 9 do
    table.insert(configKeys, {
        key = tostring(i),
        mods = "LEADER",
        action = wezterm.action.ActivateTab(i - 1),
    })
end

return configKeys
