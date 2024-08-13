-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Theme handling library
local beautiful = require("beautiful")
beautiful.init(gears.filesystem.get_configuration_dir() .. "theme/theme.lua")
-- Widget and layout library
local wibox = require("wibox")
local battery_widget = require("ui.widgets.battery.battery")
local network_widget = require("ui.widgets.network.init")
local cpu_widget = require("ui.widgets.cpu-widget.cpu-widget")
local ram_widget = require("ui.widgets.ram-widget.ram-widget")
local volume_widget = require("ui.widgets.volume-widget.volume")
local menubar = require("menubar")
-- Notification library
local naughty = require("naughty")
-- Delcaritize object management
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

local debian = require("debian.menu")
local has_fdo, freedesktop = pcall(require, "freedesktop")


-- This is used later as the default terminal and editor to run.
terminal = "wezterm start --always-new-process"
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor
file_manager = "nautilus"
app_launcher = gears.filesystem.get_configuration_dir() .. "rofi_launcher.sh launcher"
powermenu = gears.filesystem.get_configuration_dir() .. "rofi_launcher.sh powermenu"

require("configuration")
require("modules")
require("ui")

-- -- {{{ Menu
-- -- Create a launcher widget and a main menu
-- myawesomemenu = {
--     {
--         "hotkeys",
--         function()
--             hotkeys_popup.show_help(nil, awful.screen.focused())
--         end,
--     },
--     { "manual",      terminal .. " -e man awesome" },
--     { "edit config", editor_cmd .. " " .. awesome.conffile },
--     { "restart",     awesome.restart },
--     {
--         "quit",
--         function()
--             awesome.quit()
--         end,
--     },
-- }
--
-- local menu_awesome = { "awesome", myawesomemenu, beautiful.awesome_icon }
-- local menu_terminal = { "open terminal", terminal }
--
-- if has_fdo then
--     mymainmenu = freedesktop.menu.build({
--         before = { menu_awesome },
--         after = { menu_terminal },
--     })
-- else
--     mymainmenu = awful.menu({
--         items = {
--             menu_awesome,
--             { "Debian", debian.menu.Debian_menu.Debian },
--             menu_terminal,
--         },
--     })
-- end
--
-- mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = mymainmenu })
--
-- -- Menubar configuration
-- menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- -- }}}
--
-- -- Keyboard map indicator and switcher
-- mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t)
        t:view_only()
    end),
    awful.button({}, 4, function(t)
        awful.tag.viewnext(t.screen)
    end),
    awful.button({}, 5, function(t)
        awful.tag.viewprev(t.screen)
    end)
)

local tasklist_buttons = gears.table.join(
    awful.button({}, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal("request::activate", "tasklist", { raise = true })
        end
    end),
    awful.button({}, 3, function()
        awful.menu.client_list({ theme = { width = 250 } })
    end),
    awful.button({}, 4, function()
        awful.client.focus.byidx(1)
    end),
    awful.button({}, 5, function()
        awful.client.focus.byidx(-1)
    end)
)

awful.screen.connect_for_each_screen(function(s)
    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({}, 1, function()
            awful.layout.inc(1)
        end),
        awful.button({}, 3, function()
            awful.layout.inc(-1)
        end),
        awful.button({}, 4, function()
            awful.layout.inc(1)
        end),
        awful.button({}, 5, function()
            awful.layout.inc(-1)
        end)
    ))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist({
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
    })

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist({
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
    })

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup({
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        {             -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            mytextclock,
            wibox.widget.textbox("|"),
            cpu_widget({
                timeout = 5,
            }),
            wibox.widget.textbox("|"),
            ram_widget({
                timeout = 5,
            }),
            wibox.widget.textbox("|"),
            network_widget.wireless({
                interface = "wlp1s0",
            }),
            network_widget.indicator({
                interface = "eno1",
            }),
            network_widget.internet({}),
            wibox.widget.textbox("|"),
            volume_widget({}),
            wibox.widget.textbox("|"),
            battery_widget {},
            s.mylayoutbox,
        },
    })
end)
-- }}}

--- Enable for lower memory consumption
collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)
gears.timer({
    timeout = 5,
    autostart = true,
    call_now = true,
    callback = function()
        collectgarbage("collect")
    end,
})
