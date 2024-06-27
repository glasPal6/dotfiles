local themes_path = require("gears.filesystem").get_configuration_dir() .. "theme/"
local dpi = require("beautiful.xresources").apply_dpi

-- {{{ Main
local theme = {}
theme.wallpaper = themes_path .."nord1.png"
-- }}}

-- {{{ Styles
theme.font      = "MesloLGS NF 8"

-- {{{ Colors
nord0 = "#2e3440"
nord1 = "#3b4252"
nord2 = "#434c5e"
nord3 = "#4c566a"
nord4 = "#d8dee9"
nord5 = "#e5e9f0"
nord6 = "#eceff4"
nord7 = "#8fbcbb"
nord8 = "#88c0d0"
nord9 = "#81a1c1"
nord10 = "#5E81AC"
nord11 = "#bf616a"
nord12 = "#d08770"
nord13 = "#ebcb8b"
nord14 = "#a3be8c"
nord15 = "#b48ead"

theme.fg_normal  = nord4
theme.fg_focus   = nord5
theme.fg_urgent  = nord6
theme.bg_normal  = nord1
theme.bg_focus   = nord2
theme.bg_urgent  = nord3
theme.bg_systray = theme.bg_normal
-- }}}

-- {{{ Borders
-- theme.useless_gap   = dpi(0)
theme.useless_gap   = dpi(3)
theme.border_width  = dpi(2)
theme.border_normal = nord7
theme.border_focus  = nord8
theme.border_marked = nord9
-- }}}

-- {{{ Titlebars
theme.titlebar_bg_focus  = nord2
theme.titlebar_bg_normal = nord1
-- }}}

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- titlebar_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- Example:
--theme.taglist_bg_focus = "#CC9393"
-- }}}

-- {{{ Widgets
-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.fg_widget        = "#AECF96"
--theme.fg_center_widget = "#88A175"
--theme.fg_end_widget    = "#FF5656"
--theme.bg_widget        = "#494B4F"
--theme.border_widget    = "#3F3F3F"
-- }}}

-- {{{ Mouse finder
theme.mouse_finder_color = nord10
-- mouse_finder_[timeout|animate_timeout|radius|factor]
-- }}}

-- {{{ Menu
-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_height = dpi(15)
theme.menu_width  = dpi(100)
-- }}}

-- {{{ Icons
-- {{{ Taglist
theme.taglist_squares_sel   = themes_path .. "taglist/squarefz.png"
theme.taglist_squares_unsel = themes_path .. "taglist/squarez.png"
--theme.taglist_squares_resize = "false"
-- }}}

-- {{{ Misc
theme.awesome_icon           = themes_path .. "awesome-icon.png"
theme.menu_submenu_icon      = themes_path .. "default/submenu.png"
-- }}}

-- {{{ Layout
theme.layout_tile       = themes_path .. "layouts/tile.png"
theme.layout_tileleft   = themes_path .. "layouts/tileleft.png"
theme.layout_tilebottom = themes_path .. "layouts/tilebottom.png"
theme.layout_tiletop    = themes_path .. "layouts/tiletop.png"
theme.layout_fairv      = themes_path .. "layouts/fairv.png"
theme.layout_fairh      = themes_path .. "layouts/fairh.png"
theme.layout_spiral     = themes_path .. "layouts/spiral.png"
theme.layout_dwindle    = themes_path .. "layouts/dwindle.png"
theme.layout_max        = themes_path .. "layouts/max.png"
theme.layout_fullscreen = themes_path .. "layouts/fullscreen.png"
theme.layout_magnifier  = themes_path .. "layouts/magnifier.png"
theme.layout_floating   = themes_path .. "layouts/floating.png"
theme.layout_cornernw   = themes_path .. "layouts/cornernw.png"
theme.layout_cornerne   = themes_path .. "layouts/cornerne.png"
theme.layout_cornersw   = themes_path .. "layouts/cornersw.png"
theme.layout_cornerse   = themes_path .. "layouts/cornerse.png"
-- }}}

-- {{{ Titlebar
theme.titlebar_close_button_focus  = themes_path .. "titlebar/close_focus.png"
theme.titlebar_close_button_normal = themes_path .. "titlebar/close_normal.png"

theme.titlebar_minimize_button_normal = themes_path .. "default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = themes_path .. "default/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_focus_active  = themes_path .. "titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active = themes_path .. "titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive  = themes_path .. "titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive = themes_path .. "titlebar/ontop_normal_inactive.png"

theme.titlebar_sticky_button_focus_active  = themes_path .. "titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active = themes_path .. "titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive  = themes_path .. "titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive = themes_path .. "titlebar/sticky_normal_inactive.png"

theme.titlebar_floating_button_focus_active  = themes_path .. "titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active = themes_path .. "titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive  = themes_path .. "titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive = themes_path .. "titlebar/floating_normal_inactive.png"

theme.titlebar_maximized_button_focus_active  = themes_path .. "titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active = themes_path .. "titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = themes_path .. "titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = themes_path .. "titlebar/maximized_normal_inactive.png"
-- }}}
-- }}}

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
