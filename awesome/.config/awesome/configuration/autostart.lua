local awful = require("awful")
local filesystem = require("gears.filesystem")
local config_dir = filesystem.get_configuration_dir()
local helpers = require("helpers")

local function autostart_apps()
    -- Monitors
    helpers.run.run_once_grep("autorandr --change")
    awful.spawn.with_shell(
        "xautolock -detectsleep -time 3 -locker 'betterlockscreen -l -- --inside-color=2e3440FF --insidever-color=b48eadFF --insidewrong-color=282828FF --ring-color=3b4252FF --ringver-color=a3be3cFF --ringwrong-color=FB4934FF --separator-color=282828FF' -notify 30 -notifier 'notify-send -u critical -t 10000 --" ..
        "'LOCKING screen in 30 seconds'")

    --- Compositor
    -- helpers.run.check_if_running("picom", nil, function()
    -- 	awful.spawn("picom --config " .. config_dir .. "configuration/picom.conf", false)
    -- end)

    -- Apps
    helpers.run.check_if_running("brave-browser", nil, function()
        awful.spawn("brave-browser", false)
    end)
    -- helpers.run.check_if_running("superproductivity", nil, function()
    --     awful.spawn("superproductivity", false)
    -- end)

    --- Other stuff
    helpers.run.run_once_grep("blueman-applet")
    helpers.run.run_once_grep("nm-applet")
end

autostart_apps()
