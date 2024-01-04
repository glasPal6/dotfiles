#!/bin/sh

run() {
  if ! pgrep -f "$1" ;
  then
    "$@"&
  fi
}

run "picom"
run "brave-browser"
run "redshift"

killall -q polybar
polybar left &
polybar right &
polybar middle &
polybar tray &
polybar xwindow &
