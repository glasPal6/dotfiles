return function(wezterm)
    wezterm.on("gui-startup", function(cmd)
        local tab, build_pane, window = wezterm.mux.spawn_window({
            workspace = "Base",
            cwd = wezterm.home_dir,
            args = args,
        })

        local args = {}
        if cmd then
            args = cmd.args
        end

        -- Maximize on startup
        -- local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
        -- window:gui_window():maximize()

        local tab, build_pane, window = wezterm.mux.spawn_window({
            workspace = "Projects",
            cwd = wezterm.home_dir .. "/Documents/Personal_Projects",
            args = args,
        })
        -- tab:set_title("coding")
        -- local editor_pane = build_pane:split({
        --     direction = "Left",
        --     size = 0.6,
        --     cwd = wezterm.home_dir,
        -- })
        -- local tab, window = build_pane:move_to_new_tab()

        local tab, build_pane, window = wezterm.mux.spawn_window({
            workspace = "University",
            cwd = wezterm.home_dir .. "/Documents/University",
            args = args,
        })
    end)
end
