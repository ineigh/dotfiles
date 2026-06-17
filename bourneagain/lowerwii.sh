#!/bin/bash
SOURCE="alsa_input.usb-MACROSILICON_UGREEN_HDMI_Capture_20230424-02.analog-stereo"
CUR_VOL=$(pactl get-source-volume $SOURCE | grep -o '[0-9]\+%' | head -n 1 | tr -d "%")

if [[ $((CUR_VOL)) -le 5 ]]; then
	LOWERED_VOL=0
else
	LOWERED_VOL=$(($CUR_VOL - 5))
fi

pactl set-source-volume "$SOURCE" "$LOWERED_VOL%"

qdbus org.kde.plasmashell /org/kde/osdService org.kde.osdService.volumeChanged "$LOWERED_VOL"
