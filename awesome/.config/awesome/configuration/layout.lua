local awful = require("awful")
local bling = require("modules.bling")

--- Custom Layouts
local mstab = bling.layout.mstab
local centered = bling.layout.centered
local equal = bling.layout.equalarea
local deck = bling.layout.deck

--- Set the layouts
tag.connect_signal("request::default_layouts", function()
    awful.layout.append_default_layouts({
        awful.layout.suit.tile,
        awful.layout.suit.spiral.dwindle,
        awful.layout.suit.floating,
        awful.layout.suit.max,
        centered,
        mstab,
        equal,

        -- awful.layout.suit.tile,
        -- awful.layout.suit.fair,
        -- awful.layout.suit.spiral,
        -- awful.layout.suit.max,
    })
end)
