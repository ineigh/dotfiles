export EDITOR=vim
export VISUAL=vim
export SUDO_EDITOR=vim

#BASH PROMPT
PS1='\[\e[0;35m\]\u\[\e[0;32m\]@\[\e[0;36m\]\h\[\e[0;34m\] [ \w\[\e[0;34m\] ]\[\e[0;90m\] \n\[\e[1;31m\]Ω\[\e[0;33m\] \$\[\e[0m\] '

#ALIASES
alias reboot='systemctl reboot'
alias shutdown='systemctl poweroff'
alias n='neofetch'
alias ls='ls -l --color=auto'
alias lsa='ls -l -a --color=auto'
alias grep='grep --color=auto'
alias rc='vim $HOME/.bashrc'
alias rb='source ~/.bashrc'
alias ki='vim $HOME/.config/kitty/kitty.conf'
alias fo='vim $HOME/.config/foot/foot.ini'
alias neoconf='vim $HOME/.config/neofetch/config.conf'
alias ponysay='python3 -W ignore /usr/bin/ponysay -b round'
alias vrc='vim .vimrc'
alias ls='ls -l --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias mkpth='mkdir -p'
alias xtrct='tar -xvzf'
alias lsrc='ls | grep "$@"'

#FUNNY
case $(date +%u) in
	2)
		ponysay -f trixielulamoon "It's Trixie Tuesday!"
		;;
	5)
		ponysay -f fluttershy "It's Fluttershy Friday, yay!"
		;;
esac

#WRAPPERS
apt() {
	case $1 in
		"upd")
			sudo apt update
			;;
		"rem")
			sudo apt remove "${@:2}"
			;;
		"cln")
			sudo apt autoremove
			;;
		"ins")
			sudo apt install "${@:2}"
			;;
		"upg")
			sudo apt upgrade
			;;
		"src")
			sudo apt search "${@:2}"
			;;
		"rins")
			sudo apt reinstall "${@:2}"
			;;
		"updg")
			sudo apt update && sudo apt upgrade
			;;
        "all")
            flatpak update -y && sudo apt update -y && sudo apt upgrade -y
            ;;
		*)
			sudo apt "$@"
			;;
	esac
	
	local status=$?

    if [ $status -eq 0 ]; then
        ponysay -f pinkie "Operation Successful! Yippie!"
    else
        ponysay -f pinkamena "Something went wrong..."
		echo "Exit code: $status"
    fi
}

ffconv() {
	if [ ! -d ~/ffmpeg ]; then
		mkdir ~/ffmpeg
	fi

	if [ $3 = "-here" ] || [ $3 = "-h" ]; then
		strippedpath="$(cd -- "$(dirname -- "$1")" && pwd)/"
		outpath="${strippedpath}${2}"
	else
		outpath="$HOME/ffmpeg/$2"
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
	yt-dlp -U

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
		"$palette" || { echo "Palettegen error"; return 1; }
	
	ffmpeg -v error -y -i "$filepath" -i "$palette" \
		-lavfi "fps=15,scale=480:-2:flags=lanczos [x]; [x][1:v] paletteuse" \
		-loop 0 \
		"$output" || { echo "Conversion error"; return 1; }
	
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
dol() {
	if [ -z "$1" ]; then
		ponysay -f silverspoon "Opening $PWD for you."
		sleep 1
		nohup dolphin "$PWD" >/dev/null 2>&1 &
		disown
	else
		if [ ! -d "$1" ]; then
			ponysay -f babsseed "That isn't a directory!"
		else
			ponysay -f diamondtiara "Opening $1 for you."
			sleep 1
			nohup dolphin $1 >/dev/null 2>&1 &
			disown
		fi
	fi
}

cdir() {
	mkdir -p $1 && cd $1
}

mlpep() {
	s=$(( (RANDOM % 9) + 1 ))

	if [ $s -eq 3 ]; then
		e=$(( (RANDOM % 13) + 1 ))
	else
		e=$(( (RANDOM % 26) +1 ))
	fi

	en=$(jq -r ".\"$s\".\"$e\"" "$HOME/mlp.json")

	ponysay +f fillystia "You should watch Episode $e, Season $s: \"$en\" of My Little Pony!"
}

#MISC/OPTIONS

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
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
