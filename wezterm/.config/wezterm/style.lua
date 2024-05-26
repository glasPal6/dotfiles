local wezterm = require("wezterm")

return function(config)
    config.enable_wayland = true
    config.font = wezterm.font("MesloLGS NF")
    config.font_size = 9
    config.color_scheme = "nord"

    config.use_fancy_tab_bar = false
    config.colors = {
        tab_bar = {
            background = "#2E3440",
            active_tab = {
                bg_color = "#3B4252",
                fg_color = "#8FBCBB",
                intensity = "Bold",
            },
            inactive_tab = {
                bg_color = "#3B4252",
                fg_color = "#ECEFF4",
            },
            inactive_tab_hover = {
                bg_color = "#3B4252",
                fg_color = "#ECEFF4",
                italic = true,
            },
            new_tab = {
                bg_color = "#3B4252",
                fg_color = "#ECEFF4",
            },
            new_tab_hover = {
                bg_color = "#3B4252",
                fg_color = "#ECEFF4",
                italic = true,
            },
        },
    }
    config.status_update_interval = 1000
    wezterm.on("update-status", function(window, pane)
        -- Colors
        local tab_colors = {
            nord1 = "#3B4252",
            nord3 = "#4C566A",
            nord5 = "#E5E9F0",
            nord6 = "#ECEFF4",
            nord7 = "#8FBCBB",
            nord8 = "#88C0D0",
            nord13 = "#EBCB8B",
        }

        -- Workspace name
        local stat = window:active_workspace()
        if window:active_key_table() then
            stat = window:active_key_table()
        end
        if window:leader_is_active() then
            stat = "LDR"
        end

        local basename = function(s)
            return string.gsub(s, "(.*[/\\])(.*)", "%2")
        end
        local cwd_uri = pane:get_current_working_dir()
        local cwd = ""
        if cwd_uri then
            cwd = cwd_uri.path
        end

        local cmd = pane:get_foreground_process_name()
        cmd = cmd and basename(cmd) or ""

        -- Time and date
        local date = wezterm.strftime("%Y-%m-%d")
        local time = wezterm.strftime("%H:%M:%S")

        -- Domain
        local session_name = "Base"
        for i, v in ipairs(config.unix_domains) do
            if v.name ~= nil and v.name ~= "" then
                session_name = v.name
                break
            end
        end

        -- Left status (left of the tab line)
        window:set_left_status(wezterm.format({
            { Foreground = { Color = tab_colors.nord1 } },
            { Background = { Color = tab_colors.nord8 } },
            { Text = "  " .. wezterm.nerdfonts.cod_workspace_trusted .. "  " .. stat .. " " },
            { Foreground = { Color = tab_colors.nord8 } },
            { Background = { Color = tab_colors.nord1 } },
            { Text = "" },
        }))

        -- Right status
        window:set_right_status(wezterm.format({
            { Foreground = { Color = tab_colors.nord3 } },
            { Text = "" },
            { Foreground = { Color = tab_colors.nord5 } },
            { Background = { Color = tab_colors.nord3 } },
            -- { Text = "  " .. wezterm.nerdfonts.md_folder .. "  " .. cwd .. " " },
            { Text = "  " .. wezterm.nerdfonts.md_folder .. "  " .. session_name .. " " },
            { Foreground = { Color = tab_colors.nord1 } },
            { Background = { Color = tab_colors.nord3 } },
            { Text = "" },
            { Foreground = { Color = tab_colors.nord5 } },
            { Background = { Color = tab_colors.nord1 } },
            { Text = "  " .. wezterm.nerdfonts.md_calendar .. "  " .. date .. " " },
            { Foreground = { Color = tab_colors.nord8 } },
            { Background = { Color = tab_colors.nord1 } },
            { Text = "" },
            { Foreground = { Color = tab_colors.nord1 } },
            { Background = { Color = tab_colors.nord8 } },
            { Text = "  " .. wezterm.nerdfonts.md_clock .. "  " .. time .. " " },
        }))
    end)
end
