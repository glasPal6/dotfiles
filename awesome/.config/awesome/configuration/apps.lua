local filesystem = require("gears.filesystem")
local config_dir = filesystem.get_configuration_dir()
local utils_dir = config_dir .. "utilities/"

return {
    --- Default Applications
    default = {
        --- Default terminal emulator
        terminal = "wezterm start --always-new-process",
        --- Default music client
        music_player = "wezterm start --class music ncmpcpp",
        --- Default text editor
        text_editor = "wezterm start nvim",
        --- Default web browser
        web_browser = "zen -P Running",
        --- Default file manager
        file_manager = "nautilus",
        --- Default network manager
        network_manager = "wezterm start nmtui",
        --- Default bluetooth manager
        bluetooth_manager = "blueman-manager",
        --- Default power manager
        power_manager = "xfce4-power-manager",
        --- Default rofi global menu
        app_launcher = "rofi -no-lazy-grab -show drun -modi drun -theme "
            .. config_dir
            .. "configuration/launcher.rasi",
    },

    --- List of binaries/shell scripts that will execute for a certain task
    utils = {},
}
