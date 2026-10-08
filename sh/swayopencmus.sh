#!/bin/bash

if ! tmux list-sessions | grep -q cmus; then
	tmux new-session -d -s "cmus" \; set -g status off && tmux send-keys -t "cmus" "cmus" C-m
fi
