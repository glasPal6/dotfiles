#!/bin/bash

cat > ~/.local/share/omarchy/bin/omarchy-launch-webapp <<'EOF'
#!/bin/bash

browser=$(xdg-settings get default-web-browser)

case $browser in
zen-browser* | zen.desktop)
    setsid -f uwsm app -- zen-browser -P Webapp --class "zen-webapp" --new-window "$1" "${@:2}" &>/dev/null &
    exit 0
    ;;
google-chrome* | brave-browser* | microsoft-edge* | opera* | vivaldi* | helium-browser*)
    ;;
*)
    browser="chromium.desktop"
    ;;
esac

setsid -f uwsm app -- $(sed -n 's/^Exec=\([^ ]*\).*/\1/p' {~/.local,~/.nix-profile,/usr}/share/applications/$browser 2>/dev/null | head -1) --app="$1" "${@:2}" &>/dev/null &
exit 0
EOF

chmod +x ~/.local/share/omarchy/bin/omarchy-launch-webapp
