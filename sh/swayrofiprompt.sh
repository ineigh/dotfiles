#!/bin/bash
choice=$(printf "Lock\nSuspend\nReboot\nShutdown" | rofi -dmenu \
	-p "Power" \
	-theme-str "listview { lines: 4; columns: 1; }")

case "$choice" in
Lock) swaylock -e -f -i $HOME/dotfiles/stow/sway/.config/sway/wallpapers/lock.png ;;
Suspend) loginctl suspend ;;
Reboot) loginctl reboot ;;
Shutdown) loginctl poweroff ;;
esac
