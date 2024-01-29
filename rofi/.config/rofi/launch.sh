#!/usr/bin/bash

show_launcher() {
	rofi -show drun -normal-window -theme "./launcher.rasi"
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
	echo -e "$lock\n$suspend\n$logout\n$reboot\n$hibernate\n$shutdown" | rofi -normal-window -dmenu -p "$host" -mesg "Uptime: $uptime" -theme powermenu.rasi
}

confirm_exit() {
	echo -e "$yes\n$no" | rofi -normal-window -dmenu -p "Confirmation" -mesg "Are you sure?" -theme confirm.rasi
}

run_cmd() {
	selected="$(confirm_exit)"
	if [[ "$selected" == "$yes" ]]; then
		if [[ $1 == '--shutdown' ]]; then
			systemctl poweroff
		elif [[ $1 == '--reboot' ]]; then
			systemctl reboot
		elif [[ $1 == '--suspend' ]]; then
			systemctl suspend
        elif [[ $1 == '--hibernate' ]]; then
			systemctl hibernate
		elif [[ $1 == '--logout' ]]; then
			if [[ $DESKTOP_SESSION == "sway" ]]; then
				swaymsg exit
			elif [[ $DESKTOP_SESSION == "i3" ]]; then
				i3-msg exit
			fi
		elif [[ $1 == '--lock' ]]; then
			if [[ $DESKTOP_SESSION == "sway" ]]; then
				swaylock
			elif [[ $DESKTOP_SESSION == "i3" ]]; then
				i3lock
			fi

		fi
	else
		exit 0
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
