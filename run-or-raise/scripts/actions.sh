#!/bin/sh
set -eu

OPTIONS="Lock screen
Poweroff
Reboot
Firmware
Hibernate
Suspend"

sel=$(echo "$OPTIONS" | sk)

case "$sel" in
  "Lock screen") loginctl lock-session ;;
  "Poweroff") systemctl poweroff ;;
  "Reboot") systemctl reboot ;;
  "Firmware") systemctl reboot --firmware-setup ;;
  "Hibernate") systemctl hibernate ;;
  "Suspend") systemctl suspend ;;
esac
