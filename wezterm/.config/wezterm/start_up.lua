return function(wezterm)
    wezterm.on("gui-startup", function(cmd)
        local args = {}
        if cmd then
            args = cmd.args
        end

        local tab, build_pane, window = wezterm.mux.spawn_window({
            workspace = "Base",
            cwd = wezterm.home_dir,
            args = args,
        })
    end)
end
