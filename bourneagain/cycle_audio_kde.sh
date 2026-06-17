#!/bin/bash

# Get a list of all available audio sinks (outputs) by name
sinks=($(pactl list short sinks | awk '{print $2}'))

# Get the currently active default sink
current_sink=$(pactl get-default-sink)

# Find the array index of the current sink
current_index=0
for i in "${!sinks[@]}"; do
    if [[ "${sinks[$i]}" == "$current_sink" ]]; then
        current_index=$i
        break
    fi
done

# Calculate the next index (loop back to 0 if at the end of the list)
next_index=$(( (current_index + 1) % ${#sinks[@]} ))
next_sink=${sinks[$next_index]}

# Set the next sink as the default audio output
pactl set-default-sink "$next_sink"

# Send a desktop notification so you know which device is active
notify-send -u low -t 1 "Audio Output Switched" "Now using:\n$next_sink" -i audio-speakers
