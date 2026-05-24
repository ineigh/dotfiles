#!/bin/bash
SOURCE="alsa_input.usb-MACROSILICON_UGREEN_HDMI_Capture_20230424-02.pro-input-0"
CUR_VOL=$(pactl get-source-volume $SOURCE | grep -o '[0-9]\+%' | head -n 1 | tr -d "%")

if [[ $(( CUR_VOL )) -ge 95 ]]; then
    RAISED_VOL=100
else
    RAISED_VOL=$(( $CUR_VOL + 5 ))
fi

pactl set-source-volume "$SOURCE" "$RAISED_VOL%"

# qdbus org.kde.plasmashell /org/kde/osdService org.kde.osdService.volumeChanged "$RAISED_VOL"
