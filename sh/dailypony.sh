#!/usr/bin/env bash
# DAILY PONY
lastdate="$HOME/.lastdate"
currentdate="$(date +%F)"

if [ ! -f "$lastdate" ] || [ "$(cat "$lastdate")" != "$currentdate" ]; then
	case "$(date +%u)" in
	1) ponysay -f applejack "It's AJ Monday! Yeehaw!" ;;
	2) ponysay -f trixielulamoon "It's Trixie Tuesday! Marvel upon this great and powerful day!" ;;
	3) ponysay -f pinkiegummy "It's Pinkie Wednesday! Yippie!" ;;
	4) ponysay -f twilight "It's Twilight Thursday!" ;;
	5) ponysay -f fluttershy "It's Fluttershy Friday, yay!" ;;
	6) ponysay -f rainbowsleep "It's Dash Saturday! Nap time!" ;;
	7) ponysay -f rarity "It's Rarity Sunday! Wahaha!" ;;
	esac

	printf '%s\n' "$currentdate" >"$lastdate"
fi
