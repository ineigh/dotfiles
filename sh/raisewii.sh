#!/bin/bash
source "$HOME/.profile"
CUR_VOL=$(pactl get-source-volume "$UGREEN_NODE" | grep -o '[0-9]\+%' | head -n 1 | tr -d "%")

if [[ $((CUR_VOL)) -ge 95 ]]; then
	RAISED_VOL=100
else
	RAISED_VOL=$(("$CUR_VOL" + 5))
fi

pactl set-source-volume "$UGREEN_NODE" "$RAISED_VOL%"
qdbus org.kde.plasmashell /org/kde/osdService volumeChanged "$RAISED_VOL"
