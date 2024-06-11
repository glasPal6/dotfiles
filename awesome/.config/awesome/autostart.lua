local gears = require("gears")
local awful = require("awful")

-- Monitors basic
-- awful.spawn.with_shell(gears.filesystem.get_configuration_dir() .. "monitor_display.sh")
awful.spawn.with_shell("autorandr --change")

-- Autostart applications
-- Nice apps to start
awful.spawn("brave-browser", { screen = 1, tag = "1", } )
awful.spawn("superproductivity", { screen = 2, tag = "1", } )
-- awful.spawn(terminal, { screen = 2, tag = "2" })

-- Required for the style
awful.spawn.with_shell("compton")
-- awful.spawn.with_shell("picom")

