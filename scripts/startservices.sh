#!/bin/bash

export SVDIR="$HOME/Projects/dotfiles/userservice"
runsvdir -P "$SVDIR" &
