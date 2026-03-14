#!/bin/bash

#create backups of files
mv ~/.bashrc ~/.bashrc.bak
mv ~/.config/konsolerc ~/.config/konsolerc.bak
mv ~/.config/yakuakerc ~/.config/yakuakerc.bak
mv ~/.config/cmus/autosave ~/.config/cmus/autosave.bak

#create symlinks
ln -s ~/Projects/dotfiles/.bashrc ~/.bashrc
ln -s ~/Projects/dotfiles/.vimrc ~/.vimrc
ln -s ~/Projects/dotfiles/.config/konsolerc ~/.config/konsolerc
ln -s ~/Projects/dotfiles/.config/yakuakerc ~/.config/yakuakerc
ln -s ~/Projects/dotfiles/.config/cmus/autosave ~/.config/cmus/autosave
ln -s ~/Projects/dotfiles/.local/share/konsole/Oblivion.profile ~/.local/share/konsole/Oblivion.profile
ln -s ~/Projects/dotfiles/.local/share/konsole/Sweet.colorscheme ~/.local/share/konsole/Sweet.colorscheme
ln -s ~/Projects/dotfiles/.vim/colors/aldmeris.vim ~/.vim/colors/aldmeris.vim

ponysay -f twilight "All done!"
