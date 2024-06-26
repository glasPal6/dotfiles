local gears                                           = require("gears")
local gfs                                             = require("gears.filesystem")
local themes_path                                     = gfs.get_themes_dir()
local theme                                           = dofile(themes_path .. "default/theme.lua")
local theme_assets                                    = require("beautiful.theme_assets")
local xresources                                      = require("beautiful.xresources")
local dpi                                             = xresources.apply_dpi
local helpers                                         = require("helpers")
local icons                                           = require("icons")

--- Ui Fonts
theme.font_name                                       = "MesloLGS NF "
theme.font                                            = theme.font_name .. "8"

--- Icon Fonts
theme.icon_font                                       = "Material Icons "

-- Colours
theme.nord0                                           = "#2e3440"
theme.nord1                                           = "#3b4252"
theme.nord2                                           = "#434c5e"
theme.nord3                                           = "#4c566a"
theme.nord4                                           = "#d8dee9"
theme.nord5                                           = "#e5e9f0"
theme.nord6                                           = "#eceff4"
theme.nord7                                           = "#8fbcbb"
theme.nord8                                           = "#88c0d0"
theme.nord9                                           = "#81a1c1"
theme.nord10                                          = "#5E81AC"
theme.nord11                                          = "#bf616a"
theme.nord12                                          = "#d08770"
theme.nord13                                          = "#ebcb8b"
theme.nord14                                          = "#a3be8c"
theme.nord15                                          = "#b48ead"

theme.transparent                                     = "#00000000"

theme.bg_normal                                       = theme.nord1
theme.bg_focus                                        = theme.nord2
theme.bg_urgent                                       = theme.nord3
theme.bg_systray                                      = theme.bg_normal
theme.bg_minimize                                     = theme.bg_normal

theme.fg_normal                                       = theme.nord4
theme.fg_focus                                        = theme.nord5
theme.fg_urgent                                       = theme.nord6
theme.fg_minimize                                     = theme.nord7

--- UI events
theme.leave_event                                     = theme.transparent
theme.enter_event                                     = "#ffffff" .. "10"
theme.press_event                                     = "#ffffff" .. "15"
theme.release_event                                   = "#ffffff" .. "10"

--- Widgets
theme.widget_bg                                       = theme.nord1

--- Titlebars
theme.titlebar_enabled                                = false
theme.titlebar_bg                                     = theme.nord1
theme.titlebar_fg                                     = theme.nord4

local icon_dir                                        = gfs.get_configuration_dir() .. "/icons/titlebar/"

-- Close Button
theme.titlebar_close_button_normal                    = icon_dir .. "normal.svg"
theme.titlebar_close_button_focus                     = icon_dir .. "close_focus.svg"
theme.titlebar_close_button_normal_hover              = icon_dir .. "close_focus_hover.svg"
theme.titlebar_close_button_focus_hover               = icon_dir .. "close_focus_hover.svg"

-- Minimize Button
theme.titlebar_minimize_button_normal                 = icon_dir .. "normal.svg"
theme.titlebar_minimize_button_focus                  = icon_dir .. "minimize_focus.svg"
theme.titlebar_minimize_button_normal_hover           = icon_dir .. "minimize_focus_hover.svg"
theme.titlebar_minimize_button_focus_hover            = icon_dir .. "minimize_focus_hover.svg"

-- Maximized Button (While Window is Maximized)
theme.titlebar_maximized_button_normal_active         = icon_dir .. "normal.svg"
theme.titlebar_maximized_button_focus_active          = icon_dir .. "maximized_focus.svg"
theme.titlebar_maximized_button_normal_active_hover   = icon_dir .. "maximized_focus_hover.svg"
theme.titlebar_maximized_button_focus_active_hover    = icon_dir .. "maximized_focus_hover.svg"

-- Maximized Button (While Window is not Maximized)
theme.titlebar_maximized_button_normal_inactive       = icon_dir .. "normal.svg"
theme.titlebar_maximized_button_focus_inactive        = icon_dir .. "maximized_focus.svg"
theme.titlebar_maximized_button_normal_inactive_hover = icon_dir .. "maximized_focus_hover.svg"
theme.titlebar_maximized_button_focus_inactive_hover  = icon_dir .. "maximized_focus_hover.svg"

--- Wibar
theme.wibar_bg                                        = theme.nord1
theme.wibar_height                                    = dpi(40)

--- Music
theme.music_bg                                        = theme.nord1
theme.music_bg_accent                                 = theme.nord2
theme.music_accent                                    = theme.nord6

-- Wallpaper
theme.wallpaper                                       = gears.surface.load_uncached(gfs.get_configuration_dir() ..
    "theme/assets/nord1.png")
-- theme.wallpaper = gears.surface.load_uncached(gfs.get_configuration_dir() .. "theme/assets/nord2.jpg")

--- Image Assets
theme.pfp                                             = gears.surface.load_uncached(gfs.get_configuration_dir() ..
    "theme/assets/pfp.png")
theme.music                                           = gears.surface.load_uncached(gfs.get_configuration_dir() ..
    "theme/assets/music.png")

--- Layout
theme.layout_floating                                 = icons.floating
theme.layout_max                                      = icons.max
theme.layout_tile                                     = icons.tile
theme.layout_dwindle                                  = icons.dwindle
theme.layout_centered                                 = icons.centered
theme.layout_mstab                                    = icons.mstab
theme.layout_equalarea                                = icons.equalarea
theme.layout_machi                                    = icons.machi

--- Icon Theme
--- Define the icon theme for application icons. If not set then the icons
--- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme                                      = "WhiteSur-dark"

--- Borders
theme.border_width                                    = 0
theme.oof_border_width                                = 0
theme.border_color_marked                             = theme.titlebar_bg
theme.border_color_active                             = theme.titlebar_bg
theme.border_color_normal                             = theme.titlebar_bg
theme.border_color_new                                = theme.titlebar_bg
theme.border_color_urgent                             = theme.titlebar_bg
theme.border_color_floating                           = theme.titlebar_bg
theme.border_color_maximized                          = theme.titlebar_bg
theme.border_color_fullscreen                         = theme.titlebar_bg

--- Corner Radius
theme.border_radius                                   = 12

--- Edge snap
theme.snap_bg                                         = theme.nord8
theme.snap_shape                                      = helpers.ui.rrect(0)

--- Main Menu
theme.main_menu_bg                                    = theme.nord2

--- Tooltip
theme.tooltip_bg                                      = theme.nord2
theme.tooltip_fg                                      = theme.nord4
theme.tooltip_font                                    = theme.font_name .. "Regular 10"

--- Hotkeys Pop Up
theme.hotkeys_bg                                      = theme.nord1
theme.hotkeys_fg                                      = theme.nord4
theme.hotkeys_modifiers_fg                            = theme.nord4
theme.hotkeys_font                                    = theme.font_name .. "Medium 12"
theme.hotkeys_description_font                        = theme.font_name .. "Regular 10"
theme.hotkeys_shape                                   = helpers.ui.rrect(theme.border_radius)
theme.hotkeys_group_margin                            = dpi(50)

--- Tag list
local taglist_square_size                             = dpi(0)
theme.taglist_squares_sel                             = theme_assets.taglist_squares_sel(taglist_square_size,
    theme.fg_normal)
theme.taglist_squares_unsel                           = theme_assets.taglist_squares_unsel(taglist_square_size,
    theme.fg_normal)

--- Tag preview
theme.tag_preview_widget_margin                       = dpi(10)
theme.tag_preview_widget_border_radius                = theme.border_radius
theme.tag_preview_client_border_radius                = theme.border_radius / 2
theme.tag_preview_client_opacity                      = 1
theme.tag_preview_client_bg                           = theme.wibar_bg
theme.tag_preview_client_border_color                 = theme.wibar_bg
theme.tag_preview_client_border_width                 = 0
theme.tag_preview_widget_bg                           = theme.wibar_bg
theme.tag_preview_widget_border_color                 = theme.wibar_bg
theme.tag_preview_widget_border_width                 = 0

--- Layout List
theme.layoutlist_shape_selected                       = helpers.ui.rrect(theme.border_radius)
theme.layoutlist_bg_selected                          = theme.widget_bg

--- Gaps
theme.useless_gap                                     = dpi(2)

--- Systray
theme.systray_icon_size                               = dpi(20)
theme.systray_icon_spacing                            = dpi(10)
theme.bg_systray                                      = theme.wibar_bg
--- theme.systray_max_rows = 2

--- Tabs
theme.mstab_bar_height                                = dpi(60)
theme.mstab_bar_padding                               = dpi(0)
theme.mstab_border_radius                             = dpi(6)
theme.mstab_bar_disable                               = true
theme.tabbar_disable                                  = true
theme.tabbar_style                                    = "modern"
theme.tabbar_bg_focus                                 = theme.nord1
theme.tabbar_bg_normal                                = theme.nord0
theme.tabbar_fg_focus                                 = theme.nord0
theme.tabbar_fg_normal                                = theme.nord15
-- theme.tabbar_position                                 = "bottom"
theme.tabbar_position                                 = "top"
theme.tabbar_AA_radius                                = 0
theme.tabbar_size                                     = 0
theme.mstab_bar_ontop                                 = true

--- Notifications
theme.notification_spacing                            = dpi(4)
theme.notification_bg                                 = theme.nord1
theme.notification_bg_alt                             = theme.nord2

--- Notif center
theme.notif_center_notifs_bg                          = theme.nord2
theme.notif_center_notifs_bg_alt                      = theme.nord3

--- Swallowing
theme.dont_swallow_classname_list                     = {
    "brave",
    -- "firefox",
    "gimp",
    -- "Google-chrome",
    "Thunar",
}

--- Layout Machi
theme.machi_switcher_border_color                     = theme.nord2
theme.machi_switcher_border_opacity                   = 0.25
theme.machi_editor_border_color                       = theme.nord2
theme.machi_editor_border_opacity                     = 0.25
theme.machi_editor_active_opacity                     = 0.25

return theme
