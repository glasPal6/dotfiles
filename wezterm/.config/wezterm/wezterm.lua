-- Pull in the wezterm API
local wezterm = require("wezterm")
local config = wezterm.config_builder()

local smart_splits = require("smart_splits")

-- Leader is the same as my old tmux prefix
config.leader = { key = " ", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	-- Terminal
	{
		mods = "",
		key = "F11",
		action = wezterm.action.ToggleFullScreen,
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
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, _, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
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

	-- General settings
	{
		mods = "LEADER",
		key = "s",
		-- action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|ALL" }),
		action = wezterm.action.ShowLauncher,
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

config.default_workspace = "Base"

config.use_fancy_tab_bar = false
config.colors = {
    tab_bar = {
        background = "#2E3440",
        active_tab = {
            bg_color = "#3B4252",
            fg_color = "#ECEFF4",
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
    }
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

	-- Left status (left of the tab line)
	window:set_left_status(wezterm.format({
		{ Foreground = { Color = tab_colors.nord1 } },
        { Background = { Color = tab_colors.nord8 } },
		{ Text = "  " .. wezterm.nerdfonts.cod_workspace_trusted .. "  " .. stat .. " "},
		{ Foreground = { Color = tab_colors.nord8 } },
        { Background = { Color = tab_colors.nord1 } },
        { Text = ""},
	}))

	-- Right status
	window:set_right_status(wezterm.format({
		{ Foreground = { Color = tab_colors.nord3 } },
        { Text = ""},
		{ Foreground = { Color = tab_colors.nord5 } },
        { Background = { Color = tab_colors.nord3 } },
		{ Text = "  " .. wezterm.nerdfonts.md_folder .. "  " .. cwd .. " "},
		{ Foreground = { Color = tab_colors.nord1 } },
        { Background = { Color = tab_colors.nord3 } },
        { Text = ""},
		{ Foreground = { Color = tab_colors.nord5 } },
        { Background = { Color = tab_colors.nord1 } },
		{ Text = "  " .. wezterm.nerdfonts.md_calendar .. "  " .. date .. " " },
		{ Foreground = { Color = tab_colors.nord8 } },
        { Background = { Color = tab_colors.nord1 } },
        { Text = ""},
		{ Foreground = { Color = tab_colors.nord1 } },
        { Background = { Color = tab_colors.nord8 } },
		{ Text = "  " .. wezterm.nerdfonts.md_clock .. "  " .. time .. " " },
	}))
end)

return config
