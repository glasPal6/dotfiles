local awful = require("awful")
local filesystem = require("gears.filesystem")
local config_dir = filesystem.get_configuration_dir()
local helpers = require("helpers")

local function autostart_apps()
    helpers.run.check_if_running("superproductivity", nil, function()
        awful.spawn("superproductivity", { screen = 2, tag = "1" })
    end)
    helpers.run.check_if_running("brave-browser", nil, function()
        awful.spawn("brave-browser", { screen = 1, tag = "1" })
    end)
end

local function autostart_compositor()
    helpers.run.check_if_running("picom", nil, function()
        awful.spawn("picom --config " .. config_dir .. "configuration/picom.conf", false)
    end)
end

local function autostart_monitors()
    awful.spawn.with_shell("autorandr --change")
    awful.spawn.with_shell(
        "xautolock -detectsleep -time 3 -locker 'betterlockscreen -l -- --inside-color=2e3440FF --insidever-color=b48eadFF --insidewrong-color=282828FF --ring-color=3b4252FF --ringver-color=a3be3cFF --ringwrong-color=FB4934FF --separator-color=282828FF' -notify 30 -notifier 'notify-send -u critical -t 10000 --" ..
        "'LOCKING screen in 30 seconds'")
end

local function autostart_misc()
    helpers.run.run_once_grep("blueman-applet")
    helpers.run.run_once_grep("nm-applet")
end

autostart_apps()
-- autostart_compositor()
autostart_monitors()
-- autostart_misc()
