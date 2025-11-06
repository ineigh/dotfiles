#!/bin/bash
set -e # abort if something goes wrong

#colors
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RESET="\033[0m"

# -- config --
DOTFILES_DIR="$HOME/dotfiles"

echo "Creating symlinks..."

find "$DOTFILES_DIR" -type f \
	! -path "*/.git/*" \
	! -name "README.md" \
	! -name "setup.sh" \
	| while IFS= read -r src; do
		dest="$HOME/${src#$DOTFILES_DIR/}"
		mkdir -p -- "$(dirname "$dest")"
		
		#backup if does not exist or is not a symlink
		if [ -e "$dest" ] && [ ! -L "$dest" ]; then
			mv -- "$dest" "${dest}.bak"
		fi
		
		#create symlinks
		ln -sfn -- "$src" "$dest"
		echo "${GREEN}Symlink for $dest created${RESET}"
	done
