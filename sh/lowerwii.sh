#!/bin/bash
source "$HOME/.profile"
CUR_VOL=$(pactl get-source-volume "$UGREEN_NODE" | grep -o '[0-9]\+%' | head -n 1 | tr -d "%")

if [[ $((CUR_VOL)) -le 5 ]]; then
	LOWERED_VOL=0
else
	LOWERED_VOL=$(("$CUR_VOL" - 5))
fi

pactl set-source-volume "$UGREEN_NODE" "$LOWERED_VOL%"
qdbus org.kde.plasmashell /org/kde/osdService volumeChanged "$LOWERED_VOL"
