local wezterm = require("wezterm")

return function(config)
	config.enable_wayland = false
	config.font = wezterm.font("JetBrains Mono")
	config.font_size = 12
	config.color_scheme = "Catppuccin Mocha"
	config.tab_bar_at_bottom = false
	config.window_decorations = "RESIZE"

	config.use_fancy_tab_bar = false
	config.colors = {
		tab_bar = {
			background = "#1e1e2e",
			active_tab = {
				bg_color = "#313244",
				fg_color = "#cdd6f4",
				intensity = "Bold",
			},
			inactive_tab = {
				bg_color = "#181825",
				fg_color = "#a6adc8",
			},
			inactive_tab_hover = {
				bg_color = "#313244",
				fg_color = "#cdd6f4",
				italic = true,
			},
			new_tab = {
				bg_color = "#181825",
				fg_color = "#a6adc8",
			},
			new_tab_hover = {
				bg_color = "#313244",
				fg_color = "#cdd6f4",
				italic = true,
			},
		},
	}
	config.status_update_interval = 1000
	wezterm.on("update-status", function(window, pane)
		-- Colors
		local tab_colors = {
			base = "#1e1e2e",
			mantle = "#181825",
			surface0 = "#313244",
			surface1 = "#45475a",
			text = "#cdd6f4",
			teal = "#94e2d5",
			yellow = "#f9e2af",
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
		local domain_name = pane:get_domain_name()
		if not domain_name then
			domain_name = "Unknown"
		end

		-- Left status (left of the tab line)
		window:set_left_status(wezterm.format({
			{ Foreground = { Color = tab_colors.base } },
			{ Background = { Color = tab_colors.teal } },
			{ Text = "  " .. wezterm.nerdfonts.cod_workspace_trusted .. "  " .. stat .. " " },
			{ Foreground = { Color = tab_colors.teal } },
			{ Background = { Color = tab_colors.surface0 } },
			{ Text = "" },
		}))

		-- Right status
		window:set_right_status(wezterm.format({
			{ Foreground = { Color = tab_colors.surface1 } },
			{ Text = "" },
			{ Foreground = { Color = tab_colors.text } },
			{ Background = { Color = tab_colors.surface1 } },
			{ Text = "  " .. wezterm.nerdfonts.md_folder .. "  " .. domain_name .. " " },
			{ Foreground = { Color = tab_colors.base } },
			{ Background = { Color = tab_colors.surface1 } },
		}))
	end)
end
