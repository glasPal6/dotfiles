return function(wezterm)
    wezterm.on("gui-startup", function(cmd)
        local args = {}
        if cmd then
            args = cmd.args
        end

        -- Maximize on startup
        local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
        window:gui_window():maximize()

        -- local tab, build_pane, window = wezterm.mux.spawn_window({
        --     workspace = "coding",
        --     cwd = wezterm.home_dir,
        --     args = args,
        -- })
        -- tab:set_title("coding")

        -- local editor_pane = build_pane:split({
        --     direction = "Left",
        --     size = 0.6,
        --     cwd = wezterm.home_dir,
        -- })
        -- local tab, window = build_pane:move_to_new_tab()
        -- local tab, build_pane, window = wezterm.mux.spawn_window({
        --     workspace = "build",
        --     cwd = wezterm.home_dir,
        --     args = args,
        -- })
    end)
end
