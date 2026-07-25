#!/bin/bash

main=""

swaymsg -m -t subscribe '["window"]' |
	while read -r _; do
		mapfile -t ids < <(
			swaymsg -t get_tree | jq -r '
            .. | objects
            | select(.app_id? == "thunar")
            | .id
        '
		)

		((${#ids[@]})) || continue

		[[ -n $main ]] || main="${ids[0]}"

		for id in "${ids[@]}"; do
			[[ $id == "$main" ]] && continue
			swaymsg "[con_id=$id] floating enable" >/dev/null
		done
	done
