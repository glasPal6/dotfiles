local awful = require("awful")

function lock_screen_show()
    awful.spawn.with_shell("i3lock -e -i ~/dotfiles/awesome/.config/awesome/theme/assets/nord1.png -k -C")
end
