set -o vi
bind -f ~/.inputrc
export EDITOR=nvim
export VISUAL=nvim
export SUDO_EDITOR=nvim

#BASH PROMPT
PS1='\[\e[0;35m\]\u\[\e[0;32m\]@\[\e[0;36m\]\h\[\e[0;34m\] [ \w\[\e[0;34m\] ]\[\e[0;90m\] \n\[\e[1;31m\]Ω\[\e[0;33m\] \$\[\e[0m\] '

#ALIASES
alias vpm='sudo vpm --color=true'
alias vsv='sudo vsv'
alias fuz='fuzzypkg'
alias nv='nvim'
alias sued='sudoedit'
alias c='cmus'
alias f='fastfetch'
alias ls='ls -l --color=auto'
alias lsls='ls -l --color=auto | grep'
alias lsa='ls -l -a --color=auto'
alias lsals='ls -l -a --color=auto | grep'
alias grep='grep --color=auto'
alias rc='nvim $HOME/.bashrc'
alias rb='source ~/.bashrc'
alias ponysay='PYTHONWARNINGS="ignore" ponysay -b round'
alias grep='grep --color=auto'
alias hls='cat ~/.bash_history | grep "$@"'
alias wiiaudio="tmux new-session -d -s 'WiiAudio' && tmux send-keys -t 'WiiAudio' '$HOME/dotfiles/bourneagain/wiiaudio.sh' C-m"
alias killwii='tmux kill-session -t "WiiAudio"'
alias voidsv='ssh z@192.168.1.130'
alias q='exit'
alias rootfind='sudo find / -type s -name'

#FUNNY
if [ "$(date +%D)" != "$(cat $HOME/.lastdate)" ]; then
	case $(date +%u) in
	1)
		ponysay -f applejack "It's AJ Monday! Yeehaw!"
		;;
	2)
		ponysay -f trixielulamoon "It's Trixie Tuesday! Marvel upon this great and powerful day!"
		;;
	3)
		ponysay -f pinkiegummy "It's Pinkie Wednesday! Yippie!"
		;;
	4)
		ponysay -f twilight "It's Twilight Thursday!"
		;;
	5)
		ponysay -f fluttershy "It's Fluttershy Friday, yay!"
		;;
	6)
		ponysay -f rainbowsleep "It's Dash Saturday! Nap time!"
		;;
	7)
		ponysay -f rarity "It's Rarity Sunday! Wahaha!"
		;;
	esac
	echo "$(date +%D)" >$HOME/.lastdate
fi

#VOID SERVICES
ser() {
	case "$1" in
	"ln")
		if [[ -d "/etc/sv/$2" ]]; then
			sudo ln -s "/etc/sv/$2" "/var/service/$2"
		else
			echo "That service does not exist."
		fi
		;;
	"rm")
		if [[ -d "/var/service/$2" ]]; then
			sudo rm "/var/service/$2"
		else
			echo "That service has not been enabled in /var/service/ or does not exist."
		fi
		;;
	"st")
		if [[ -d "/var/service/$2" ]]; then
			sudo sv status "$2"
		else
			echo "That service has not been enabled in /var/service/ or does not exist."
		fi
		;;
	"ls")
		case "$2" in
		"all" | "a")
			ls /etc/sv/
			;;
		"run" | "r")
			ls /var/service/
			;;
		*)
			echo "Options: all/a, run/r."
			;;
		esac
		;;
	*)
		echo "Options: ln, rm, st, ls (a/r)"
		;;
	esac
}

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

ffconv() {
	if [ ! -d $HOME/Videos/ffmpeg ]; then
		mkdir $HOME/Videos/ffmpeg
	fi

	if [ $3 = "-here" ] || [ $3 = "-h" ]; then
		strippedpath="$(cd -- "$(dirname -- "$1")" && pwd)/"
		outpath="${strippedpath}${2}"
	else
		outpath="$HOME/Videos/ffmpeg/$2"
	fi

	ffmpeg -i "$1" "$outpath"
	local status=$?

	if [ $status -eq 0 ]; then
		ponysay -f vinyl "Conversion successful! Converted file saved in $outpath"
		rm -- $1
	else
		ponysay -f octavia "A conversion error has occurred."
	fi
}

dlp() {
	sudo yt-dlp -U

	if [ ! -d $HOME/Videos/DLP ]; then
		mkdir $HOME/Videos/DLP
	fi

	yt-dlp --restrict-filenames --cookies-from-browser firefox -P $HOME/Videos/DLP "$@"

	local status=$?

	if [ $status -eq 0 ]; then
		ponysay -f derpysit "Video downloaded successfully!"
	else
		ponysay -f derpysad "I just don't know what went wrong..."
	fi
}

twtgif() {
	local url="$1"
	local outdir="$HOME/Videos/DLP"

	local filepath
	yt-dlp -U
	filepath=$(yt-dlp \
		-P "$outdir" \
		--no-playlist \
		--restrict-filenames \
		--print after_move:filepath \
		"$url") || return 1

	local output="${filepath%.*}.gif"
	local palette
	palette="$(mktemp --suffix=.png)"
	trap 'rm -f -- "$palette"' RETURN

	ffmpeg -v error -y -i "$filepath" \
		-vf "fps=15,scale=480:-2:flags=lanczos,palettegen" \
		"$palette" || {
		echo "Palettegen error"
		return 1
	}

	ffmpeg -v error -y -i "$filepath" -i "$palette" \
		-lavfi "fps=15,scale=480:-2:flags=lanczos [x]; [x][1:v] paletteuse" \
		-loop 0 \
		"$output" || {
		echo "Conversion error"
		return 1
	}

	rm "$filepath"

	local status=$?
	if [ $status -eq 0 ]; then
		msg="GIF Downloaded and converted successfully!"
	else
		msg="There was an issue... try again..."
	fi

	ponysay -f lyrabonbon "$msg"
}

#FUNCTIONS
thu() {
	if [ -z "$1" ]; then
		ponysay -f silverspoon "Opening $PWD for you."
		sleep 1
		nohup thunar "$PWD" >/dev/null 2>&1 &
		disown
	else
		if [ ! -d "$1" ]; then
			ponysay -f babsseed "That isn't a directory!"
		else
			ponysay -f diamondtiara "Opening $1 for you."
			sleep 1
			nohup thunar $1 >/dev/null 2>&1 &
			disown
		fi
	fi
}

lssrc() {
	if [ ! -d "$1" ]; then
		ls -a | grep "$@"
	else
		ls -a "$1" | grep "$2"
	fi
}

mlpep() {
	s=$(((RANDOM % 9) + 1))

	if [ $s -eq 3 ]; then
		e=$(((RANDOM % 13) + 1))
	else
		e=$(((RANDOM % 26) + 1))
	fi

	en=$(jq -r ".\"$s\".\"$e\"" "$HOME/Projects/dotfiles/.mlp.json")

	ponysay +f fillystia "You should watch Episode $e, Season $s: \"$en\" of My Little Pony!"
}

#MISC/OPTIONS

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

# ~/.bash_aliases, instead of adding them here directly.
#if [ -f ~/.bash_aliases ]; then
#    . ~/.bash_aliases
#fi
# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
#if ! shopt -oq posix; then
#  if [ -f /usr/share/bash-completion/bash_completion ]; then
#    . /usr/share/bash-completion/bash_completion
#  elif [ -f /etc/bash_completion ]; then
#    . /etc/bash_completion
#  fi
#fi
. "/home/z/.deno/env"
# source /home/z/.local/share/bash-completion/completions/deno.bash

# if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
#   exec tmux
# fi
