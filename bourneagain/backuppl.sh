#!/bin/bash

cp ~/.config/cmus/playlists/* ~/.config/cmus/backup-pl/

cmus-remote -C "add ~/Music/Sorted/"
