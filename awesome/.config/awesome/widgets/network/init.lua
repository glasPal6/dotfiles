package.loaded.net_widgets = nil

local net_widgets = {
    indicator   = require("widgets.network.indicator"),
    wireless    = require("widgets.network.wireless"),
    internet    = require("widgets.network.internet")
}

return net_widgets
