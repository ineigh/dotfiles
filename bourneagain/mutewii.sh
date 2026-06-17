#!/bin/bash
SOURCE="alsa_input.usb-MACROSILICON_UGREEN_HDMI_Capture_20230424-02.pro-input-0"

pactl set-source-mute "$SOURCE" toggle
