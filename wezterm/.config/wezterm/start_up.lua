local wezterm = require("wezterm")
local mux = wezterm.mux
local config = {}

wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
	local args = {}
	if cmd then
		args = cmd.args
	end

	local tab, build_pane, window = wezterm.mux.spawn_window({
		workspace = "Base",
		cwd = wezterm.home_dir,
		args = args,
	})

	local tab, pane, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

return config
