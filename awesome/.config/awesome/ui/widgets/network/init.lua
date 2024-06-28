package.loaded.net_widgets = nil

local net_widgets = {
    indicator = require("ui/widgets/network/indicator"),
    wireless  = require("ui/widgets/network/wireless"),
    internet  = require("ui/widgets/network/internet")
}

return net_widgets
