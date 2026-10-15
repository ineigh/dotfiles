set -o vi
bind -f ~/.inputrc
export EDITOR=nvim
export VISUAL=nvim
export SUDO_EDITOR=nvim
UGREEN_NODE="$(pactl -f json list sources | jq -r '.[] | select(.name | contains("UGREEN")) | .name')"
export UGREEN_NODE
fm=dolphin

#BASH PROMPT
PS1='\[\e[38;5;117m\]\u\[\e[38;5;219m\]Ω\[\e[38;5;154m\]\h\[\e[34m\] \[\e[38;5;220m\][\[\e[38;5;220m\]\W\[\e[38;5;220m\]]\[\e[90m\] \[\e[38;5;160m\]\\$\[\e[0m\] '

#ALIASES
#NIX
alias nrs="sudo nixos-rebuild switch --flake path:/home/z/dotfiles/nix/#e14g5"
alias nfu="nix flake update nixpkgs --flake path:/home/z/dotfiles/nix/"
alias nfua="nix flake update --flake path:/home/z/dotfiles/nix/"
alias nsp="nix-shell -p"
alias ncg="sudo nix-collect-garbage -d"
alias rc2nix="nix run github:nix-community/plasma-manager/trunk#rc2nix > ~/dotfiles/nix/plasma.nix"
#MISC
alias nv="nvim"
alias sued="sudoedit"
alias stow="stow -d ~/dotfiles/stow -t ~"
alias mfoura="~/dotfiles/sh/convert_mfoura.sh"
alias ls="ls -l --color=auto"
alias lsls="ls -l --color=auto | grep"
alias lsa="ls -l -a --color=auto"
alias lsals="ls -l -a --color=auto | grep"
alias rc="nvim ~/.bashrc"
alias rb="source ~/.bashrc"
alias ponysay="PYTHONWARNINGS='ignore' ponysay -b round"
alias grep="grep --color=auto"
alias hls="cat ~/.bash_history | grep"
alias q="exit"

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

#WRAPPERS
tm() {
	case $1 in
	"ls")
		tmux list-sessions
		;;
	"at")
		tmux attach-session -t "${@:2}"
		;;
	"rm")
		tmux kill-session -t "${@:2}"
		;;
	"cm")
		tmux list-commands
		;;
	*)
		tmux "${@:1}"
		;;
	esac
}

wii() {
	case $1 in
	"en" | "enable")
		tmux new-session -d -s 'WiiAudio' && tmux send-keys -t 'WiiAudio' "$HOME/dotfiles/sh/wiiaudio.sh" C-m
		;;
	"di" | "disable")
		tmux kill-session -t WiiAudio
		;;
	*)
		echo "Usage: wii [option]"
		echo "en/enable - di/disable"
		;;
	esac
}

dlp() {
	sudo yt-dlp -U

	if [ ! -d ~/Videos/DLP ]; then
		mkdir ~/Videos/DLP
	fi

	yt-dlp --restrict-filenames --cookies-from-browser firefox --merge-output-format mp4 -P ~/Videos/DLP "$@"

	local status=$?

	if [ $status -eq 0 ]; then
		ponysay -f derpysit "Video downloaded successfully!"
	else
		ponysay -f derpysad "I just don't know what went wrong..."
	fi
}

fm() {
	if [ -z "$1" ]; then
		ponysay -f silverspoon "Opening $PWD for you."
		sleep 1
		nohup "$fm" "$PWD" >/dev/null 2>&1 &
		disown
	else
		if [ ! -d "$1" ]; then
			ponysay -f babsseed "That isn't a directory!"
		else
			ponysay -f diamondtiara "Opening $1 for you."
			sleep 1
			nohup "$fm" "$1" >/dev/null 2>&1 &
			disown
		fi
	fi
}

mlpep() {
	s=$(((RANDOM % 9) + 1))

	if [ $s -eq 3 ]; then
		e=$(((RANDOM % 13) + 1))
	else
		e=$(((RANDOM % 26) + 1))
	fi

	en=$(jq -r ".\"$s\".\"$e\"" ~/.mlp.json)

	ponysay +f fillystia "You should watch Episode $e, Season $s: \"$en\" of My Little Pony!"
}

#MISC/OPTIONS
case $- in
*i*) ;;
*) return ;;
esac

HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s checkwinsize

# if [[ -z "$TMUX" ]]; then
# 	if tmux has-session -t main 2>/dev/null; then
# 		tmux attach-session -t main
# 	else
# 		tmux new-session -s main
# 	fi
# fi
