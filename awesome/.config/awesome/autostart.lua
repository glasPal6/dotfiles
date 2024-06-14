local gears = require("gears")
local awful = require("awful")

-- Autostart applications
-- Nice apps to start
awful.spawn.once("brave-browser")
awful.spawn.once("superproductivity")
-- awful.spawn(terminal, { screen = 2, tag = "2" })

-- Compositor 
-- awful.spawn.with_shell("compton")
-- awful.spawn.with_shell("picom")
-- awful.spawn.with_shell("picom --backend glx")

-- Monitors basic
-- awful.spawn.with_shell(gears.filesystem.get_configuration_dir() .. "monitor_display.sh")
awful.spawn.with_shell("autorandr --change")

