#!/bin/bash

if swaymsg -t get_outputs | grep -q "LG"; then
	swaymsg '
	workspace Home
	move workspace to output DP-1
	'
	swaymsg '
	workspace Shed
	move workspace to output eDP-1
	'
else
	swaymsg '
	workspace Home
	move workspace to output eDP-1
	'
fi
