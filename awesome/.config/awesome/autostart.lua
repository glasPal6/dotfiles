local gears = require("gears")
local awful = require("awful")

-- Autostart applications
-- Nice apps to start
awful.spawn.once("superproductivity")
awful.spawn.once("brave-browser")
-- awful.spawn(terminal, { screen = 2, tag = "2" })

-- Compositor 
-- awful.spawn.with_shell("compton")
-- awful.spawn.with_shell("picom")
-- awful.spawn.with_shell("picom --backend glx")

-- Monitors basic
-- awful.spawn.with_shell(gears.filesystem.get_configuration_dir() .. "monitor_display.sh")
awful.spawn.with_shell("autorandr --change")
awful.spawn.with_shell("xautolock -detectsleep -time 3 -locker 'betterlockscreen -l -- --inside-color=2e3440FF --insidever-color=b48eadFF --insidewrong-color=282828FF --ring-color=3b4252FF --ringver-color=a3be3cFF --ringwrong-color=FB4934FF --separator-color=282828FF' -notify 30 -notifier 'notify-send -u critical -t 10000 --" .. "'LOCKING screen in 30 seconds'")
