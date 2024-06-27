#!/usr/bin/bash

show_launcher() {
	rofi -show drun -theme "./launcher.rasi"
}

hibernate=''
shutdown='⏻'
reboot=''
lock='󰌾'
suspend='󰏥'
logout=''
yes='󰗠'
no='󰅙'

show_powermenu() {
	uptime="$(uptime -p | sed -e 's/up //g')"
	host=$(hostnamectl hostname)
	echo -e "$lock\n$suspend\n$logout\n$reboot\n$hibernate\n$shutdown" | rofi -dmenu -p "$host" -mesg "Uptime: $uptime" -theme powermenu.rasi
}

confirm_exit() {
	echo -e "$yes\n$no" | rofi -dmenu -p "Confirmation" -mesg "Are you sure?" -theme confirm.rasi
}

run_cmd() {
    if [[ $1 == '--shutdown' ]]; then
        selected="$(confirm_exit)"
        if [[ "$selected" == "$yes" ]]; then
            systemctl poweroff
        else
            exit 0
        fi
    elif [[ $1 == '--reboot' ]]; then
        selected="$(confirm_exit)"
        if [[ "$selected" == "$yes" ]]; then
            systemctl reboot
        else
            exit 0
        fi
    elif [[ $1 == '--suspend' ]]; then
        systemctl suspend
    elif [[ $1 == '--hibernate' ]]; then
        systemctl hibernate
    elif [[ $1 == '--logout' ]]; then
        echo 'awesome.quit()' | awesome-client
    elif [[ $1 == '--lock' ]]; then
        betterlockscreen -l --off 240 --display 1 -- ie \
        --inside-color=2e3440FF \   
        --insidever-color=b48eadFF \
        --insidewrong-color=282828FF \
        --ring-color=3b4252FF \
        --ringver-color=a3be3cFF \
        --ringwrong-color=FB4934FF \
        --separator-color=282828FF
    fi
}

case "$1" in
"launcher") show_launcher ;;
"powermenu")
	choice="$(show_powermenu)"
	case $choice in
	"$shutdown")
		run_cmd --shutdown
		;;
	"$reboot")
		run_cmd --reboot
		;;
	"$lock")
		run_cmd --lock
		;;
	"$suspend")
		run_cmd --suspend
		;;
    "$hibernate")
        run_cmd --hibernate
        ;;
	"$logout")
		run_cmd --logout
		;;
	esac
	;;
esac
