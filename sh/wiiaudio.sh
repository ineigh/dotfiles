#!/bin/bash
source "$HOME/.profile"
DEADLINE=$(($(date +%s) + 300))

echo "pw cli info"
until pw-cli info 0 >/dev/null 2>&1; do
	sleep 0.5
done

echo "until pw cli ls node"
until pw-cli ls Node | grep -q "$UGREEN_NODE"; do
	if [ "$(date +%s)" -ge "$DEADLINE" ]; then
		notify-send -a "PipeWire" -i audio-card "UGREEN Capture Card not found within 5 minutes, giving up."
		echo "ugreen card not found within 5 minutes"
		exit 1
	fi
	sleep 1
done

sleep 1

pw-loopback \
	--capture-props="node.target=$UGREEN_NODE audio.rate=48000" \
	--playback-props="audio.rate=48000 audio.channels=2"

echo $! >"$HOME"/.wiiaudiopid
cat "$HOME"/.wiiaudiopid

notify-send -a "PipeWire" -i audio-card "UGREEN Capture Card" "UGREEN capture card audio is now active!"
