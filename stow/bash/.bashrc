set -o vi
bind -f ~/.inputrc
export EDITOR=nvim
export VISUAL=nvim
export SUDO_EDITOR=nvim
export fm=dolphin

#BASH PROMPT
# PS1='\[\e[0;35m\]\u\[\e[0;32m\]@\[\e[0;36m\]\h\[\e[0;34m\] \[\e[38;5;117m\][\[\e[38;5;220m\]\W\[\e[38;5;117m\]]\[\e[0m\]\[\e[0;90m\] \[\e[0;33m\]\e[0m\] '
PS1='\[\e[38;5;117m\]\u\[\e[38;5;219m\]Ω\[\e[38;5;154m\]\h\[\e[34m\] \[\e[38;5;220m\][\[\e[38;5;220m\]\W\[\e[38;5;220m\]]\[\e[90m\] \[\e[38;5;160m\]\\$\[\e[0m\] '

#ALIASES
alias nrs="sudo nixos-rebuild switch --flake ~/dotfiles/nix/#m92p"
alias nfu="nix flake update nixpkgs --flake ~/dotfiles/nix/"
alias nsp="nix-shell -p"
alias ncg="sudo nix-collect-garbage -d"
alias nv="nvim"
alias sued="sudoedit"
alias stow="stow -d ~/dotfiles/stow -t ~"
alias f="fastfetch"
alias rmus="rsync -rO --no-perms --size-only --progress"
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

#DAILY PONY
if [ ! -f ~/.latdate ]; then
	date +%D >"$HOME/.lastdate"
fi

currentdate="$(date +%D)"
lastdate="$(cat ~/.lastdate)"
ts1="$(date -d "$currentdate" +%s)"
ts2="$(date -d "$lastdate" +%s)"

if [ "$ts1" -lt "$ts2" ]; then
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
	date +%D >"$HOME/.lastdate"
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

dot() {
	if [[ -z $1 ]]; then
		cd ~/dotfiles/stow/ || exit
		nv ~/dotfiles/stow/
	else
		if [[ ! -d ~/dotfiles/stow/$1 ]]; then
			echo "Not in your dotfiles dude."
			ls ~/dotfiles/stow/
		else
			if [[ -d ~/dotfiles/stow/$1/.config/$1 ]]; then
				nv ~/dotfiles/stow/"$1"/.config/"$1"
				cd ~/dotfiles/stow/"$1"/.config/"$1" || exit
			else
				nv ~/dotfiles/stow/"$1"
				cd ~/dotfiles/stow/"$1" || exit
			fi
		fi
	fi
}

wii() {
	case $1 in
	"en" | "enable")
		tmux new-session -d -s 'WiiAudio' && tmux send-keys -t 'WiiAudio' "$HOME/dotfiles/sh/wiiaudio.sh" C-m
		;;
	"di" | "disable")
		tmux kill-session -t WiiAudio
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

# if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
#   exec tmux
# fi
