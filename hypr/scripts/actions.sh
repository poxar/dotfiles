#!/bin/sh
set -eu

OPTIONS="Lock screen
Quit
Poweroff
Reboot
Hibernate
Suspend
"

sel=$(echo "$OPTIONS" | fuzzel --dmenu)

case "$sel" in
  "Lock screen") loginctl lock-session ;;
  "Quit") hyprctl dispatch exit ;;
  "Poweroff") systemctl poweroff ;;
  "Reboot") systemctl reboot ;;
  "Hibernate") systemctl hibernate ;;
  "Suspend") systemctl suspend ;;
esac
