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
        key = "S",
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
        key = "T",
        action = wezterm.action.ShowTabNavigator,
    },
    {
        mods = "LEADER",
        key = "t",
        -- action = wezterm.action.SpawnTab("CurrentPaneDomain"),
        action = wezterm.action_callback(function(win, pane)
            local mux_win = win:mux_window()
            for _, item in ipairs(mux_win:tabs_with_info()) do
                if item.is_active then
                    mux_win:spawn_tab({})
                    win:perform_action(wezterm.action.MoveTab(item.index + 1), pane)
                    return
                end
            end
        end),
    },
    {
        mods = "LEADER|CTRL",
        key = "T",
        action = wezterm.action.PromptInputLine({
            description = wezterm.format({
                { Attribute = { Intensity = "Bold" } },
                { Foreground = { AnsiColor = "Fuchsia" } },
                { Text = "Tab Name: " },
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

    -- Terminal apps
    {
        mods = "LEADER",
        key = "m",
        action = wezterm.action.SpawnCommandInNewTab({ args = { "btop" } }),
    },
    {
        mods = "LEADER",
        key = "P",
        action = wezterm.action.SpawnCommandInNewTab({ args = { "ncdu" } }),
    },
    {
        mods = "LEADER",
        key = "g",
        action = wezterm.action.SpawnCommandInNewTab({ args = { "lazygit" } }),
    },
    {
        mods = "LEADER",
        key = "c",
        action = wezterm.action.SpawnCommandInNewTab({ args = { "lazydocker" } }),
    },

    -- Workspace navigator
    {
        key = "$",
        mods = "LEADER|SHIFT",
        action = wezterm.action.PromptInputLine({
            description = "Enter new name for Workspace",
            action = wezterm.action_callback(function(window, pane, line)
                if line then
                    wezterm.mux.rename_workspace(window:mux_window():get_workspace(), line)
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
    {
        mods = "LEADER",
        key = "e",
        action = wezterm.action.DetachDomain({ DomainName = "persistent" }),
    },
    {
        mods = "LEADER",
        key = "u",
        -- action = wezterm.action.AttachDomain("persistent"),
        action = wezterm.action_callback(function(win, pane)
            local domain = wezterm.mux.get_domain("persistent")
            -- wezterm.action.AttachDomain(domain)
            -- domain:attach()
            -- if not domain:has_any_panes() then
            local mux_win = win:mux_window()
            for _, item in ipairs(mux_win:tabs_with_info()) do
                if item.is_active then
                    mux_win:spawn_tab({ domain = { DomainName = "persistent" } })
                    win:perform_action(wezterm.action.MoveTab(item.index + 1), pane)
                    return
                end
            end
            -- end
        end),
    },

    -- General settings
    {
        mods = "LEADER",
        key = "l",
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
