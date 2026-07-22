#!/bin/bash

ext=$(swaymsg -t get_outputs | jq -r '.[] | select(.serial == "311NTFA5S947") | .name')

if [[ -n $ext && $ext != "null" ]]; then
	swaymsg "workspace Home"
	swaymsg "move workspace to output $ext"
	swaymsg "workspace Shed"
	swaymsg "move workspace to output eDP-1"
	swaymsg "bindsym Mod1+Shift+n output $ext toggle"
	swaymsg "bindsym Mod1+Shift+m output eDP-1 toggle"
	swaymsg "bindsym Mod1+Control+Shift+n output $ext enable ; output eDP-1 disable"
	swaymsg "bindsym Mod1+Control+Shift+m output $ext disable ; output eDP-1 enable"
	swaymsg "output $ext resolution 2560x1440"
	swaymsg "output eDP-1 resolution 1920x1200"
	swaymsg "output $ext position 0 0"
	swaymsg "output eDP-1 position 2580 120"
else
	swaymsg "workspace Home"
	swaymsg "move workspace to output eDP-1"
fi
