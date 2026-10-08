#!/bin/bash

if swaymsg -t get_tree | grep -q "cmus"; then
	swaymsg '[title="cmus"]' kill
else
	alacritty -o 'window.dimensions = { columns = 110, lines = 35 }' 'font.size = 17' -T cmus -e tmux attach-session -t "cmus"
fi
