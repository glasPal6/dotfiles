local gears = require("gears")
local awful = require("awful")

-- Monitors basic
awful.spawn.with_shell(gears.filesystem.get_configuration_dir() .. "monitor_display.sh")

-- Autostart applications
-- Nice apps to start
-- awful.spawn.with_shell("brave-browser")
-- awful.spawn.with_shell("superproductivity")

-- Required for the style
awful.spawn.with_shell("nitrogen --restore")
awful.spawn.with_shell("compton")
-- awful.spawn.with_shell("picom")

