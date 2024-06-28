local awful = require("awful")

function lock_screen_show()
    -- awful.spawn.with_shell("i3lock -e -k -C " .. "-i ~/dotfiles/awesome/.config/awesome/theme/assets/nord1.png")
    awful.spawn.with_shell(
        "betterlockscreen -l blur --display 0 --span --off 240 -- -C -e --inside-color=2e3440FF --ring-color=d8dee9FF --ringver-color=b48eadFF --insidever-color=ebcb8bFF --ringwrong-color=bf616aFF --insidewrong-color=d08770FF"
    )
end
