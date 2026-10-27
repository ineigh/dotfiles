set -o vi
#BASH PROMPT
PS1='\[\e[38;5;117m\]\u\[\e[38;5;219m\]Ω\[\e[38;5;154m\]\h\[\e[34m\] \[\e[38;5;220m\][\[\e[38;5;220m\]\W\[\e[38;5;220m\]]\[\e[90m\] \[\e[38;5;160m\]\\$\[\e[0m\] '

#VARIABLES AND BINDS
bind -f ~/.inputrc
export EDITOR=nvim
export VISUAL=nvim
export SUDO_EDITOR=nvim
export UGREEN_NODE
fm=dolphin

#ALIASES
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
if [[ ! -z "$TMUX" ]]; then
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
fi

#WRAPPERS
n() {
	# 0. Check for nix-shell -p
	if [[ "${1:-}" == sp ]]; then
		shift

		if (($# == 0)); then
			echo "Usage: n sp PACKAGE [PACKAGE ...]" >&2
			return 2
		fi

		nix-shell -p --command 'exec bash' "$@"
		return $?
	fi
	local arg step
	local -a steps=()
	local has_fu=false has_fua=false
	local has_r=false has_p=false

	# No arguments: show help
	if (($# == 0)); then
		n_help
		return 0
	fi

	# 1. Parse and validate the requested steps
	for arg in "$@"; do
		case "$arg" in
		h | --help)
			if (($# != 1)); then
				echo "Error: help cannot be combined with other steps." >&2
				return 2
			fi
			n_help
			;;
		fu)
			$has_fu && {
				echo "Error: duplicate step 'fu'." >&2
				return 2
			}
			has_fu=true
			;;
		fua)
			$has_fua && {
				echo "Error: duplicate step 'fua'." >&2
				return 2
			}
			has_fua=true
			;;
		cg | rc | rs)
			;;
		r)
			$has_r && {
				echo "Error: duplicate step 'r'." >&2
				return 2
			}
			has_r=true
			;;
		p)
			$has_p && {
				echo "Error: duplicate step 'p'." >&2
				return 2
			}
			has_p=true
			;;
		*)
			echo "Error: unknown step '$arg'." >&2
			return 2
			;;
		esac

		steps+=("$arg")
	done

	# 2. Check incompatible combinations
	if $has_fu && $has_fua; then
		echo "Error: 'fu' and 'fua' are mutually exclusive." >&2
		return 2
	fi

	if $has_r && $has_p; then
		echo "Error: 'r' and 'p' are mutually exclusive." >&2
		return 2
	fi

	# 3. Execute steps in the order supplied
	for step in "${steps[@]}"; do
		printf '> n%s\n' "$step"

		case "$step" in
		fu)
			nix flake update nixpkgs \
				--flake path:/home/z/dotfiles/nix/ || return
			;;
		fua)
			nix flake update \
				--flake path:/home/z/dotfiles/nix/ || return
			;;
		cg)
			sudo nix-collect-garbage -d || return
			;;
		rc)
			nix run github:nix-community/plasma-manager/trunk#rc2nix \
				>~/dotfiles/nix/plasma.nix || return
			;;
		rs)
			sudo nixos-rebuild switch \
				--flake path:/home/z/dotfiles/nix/#e14g5 || return
			;;
		r)
			sudo systemctl reboot || return
			;;
		p)
			sudo systemctl poweroff || return
			;;
		sp)
			nix-shell --command 'source ~/.bashrc' -p "$@"
			return 2
			;;
		esac
	done
}

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
	if [[ ! -z $1 ]]; then
		if [[ -d ~/dotfiles/$1 ]]; then
			nvim "$HOME/dotfiles/$1"
		else
			echo "That directory doesn't exist"
			ls ~/dotfiles/
		fi
	else
		nvim ~/dotfiles/
	fi
}

dlp() {
	# sudo yt-dlp -U

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

if [[ -z "$TMUX" ]]; then
	if tmux has-session -t main 2>/dev/null; then
		tmux attach-session -t main
	else
		tmux new-session -s main
	fi
fi

if [[ -n "${IN_NIX_SHELL:-}" ]]; then
	PS1=" $PS1"
fi

#HELPER FUNCTIONS
n_help() {
	printf '%s\n' \
		'Usage: n STEP [STEP ...]' \
		'  fu   Update nixpkgs' \
		'  ua   Update all flake inputs' \
		'  cg   Collect Nix garbage' \
		'  rc   Regenerate plasma.nix' \
		'  rs   Rebuild and switch NixOS' \
		'  r    Reboot' \
		'  p    Power off' \
		'  sp   Open nix-shell with packages (standalone)' \
		'  h    Show help'
}
