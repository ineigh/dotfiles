#!/bin/bash
# SOURCE="alsa_input.usb-MACROSILICON_UGREEN_HDMI_Capture_20230424-02.pro-input-0"
SOURCE="alsa_input.usb-MACROSILICON_UGREEN_HDMI_Capture_20230424-02.analog-stereo"

pactl set-source-mute "$SOURCE" toggle
