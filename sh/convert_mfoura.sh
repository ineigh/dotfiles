#!/usr/bin/env bash

ponysay -f rarityponder "Do you want to work on another directory instead of ~/Music/Unsorted/ ?"
read -r -p "(y/n): " ans
if [[ "$ans" == "y" || "$ans" == "Y" || "$ans" == "yes" || "$ans" == "Yes" ]]; then
	ponysay -f rarityponder "Where would you like to work then, darling?"
	while true; do
		read -e -r -p "Enter path (enter C to Cancel): " BASE_DIR

		if [[ "$BASE_DIR" == "c" || "$BASE_DIR" == "C" ]]; then
			ans="n"
			break
		else
			if [[ -d "$BASE_DIR" ]]; then
				break
			else
				ponysay -f raritycomplain "That's not a valid directory, darling..."
			fi
		fi
	done
else
	BASE_DIR="$HOME/Music/Unsorted/"
fi

outputdir=$HOME/Music/Sorted/
totalfiles=0
totalconvertedfiles=0

for folder in "$BASE_DIR"/*/; do
	[[ -d "$folder" ]] || continue

	for file in "$folder"/*.flac; do
		[[ -e "$file" ]] || continue

		song=$(ffprobe -v error -show_entries format_tags=title -of default=noprint_wrappers=1:nokey=1 "$file")
		artist_name=$(ffprobe -v error -show_entries format_tags=artist -of default=noprint_wrappers=1:nokey=1 "$file")
		album_name=$(ffprobe -v error -show_entries format_tags=album -of default=noprint_wrappers=1:nokey=1 "$file")

		[[ -n "$song" ]] || song="${file##*/}"
		[[ -n "$artist_name" ]] || artist_name="Unknown Artist"
		[[ -n "$album_name" ]] || album_name="Unknown Album"

		albumoutput="$outputdir/$artist_name/$album_name"
		mkdir -p "$albumoutput"
		totalfiles=$((totalfiles + 1))

		ponysay -f sweetiesing "Converting: $artist_name - $album_name - $song"

		ffmpeg -hide_banner -loglevel error -stats -n \
			-i "$file" \
			-map 0:a \
			-map 0:v? \
			-map_metadata 0 \
			-c:a aac \
			-b:a 320k \
			-c:v copy \
			"$albumoutput/${song%.*}.m4a"

		status=$?
		if [ $status -eq 0 ]; then
			totalconvertedfiles=$((totalconvertedfiles + 1))
		fi
	done
done

ponysay -f rarityponder "Do you want to delete the original files we've just converted?"
read -r -p "(y/n): " ans
if [[ "$ans" == "y" || "$ans" == "Y" || "$ans" == "yes" || "$ans" == "Yes" ]]; then
	rm -rf $BASE_DIR/*
fi
ponysay -f rarityfly "Wahaha! All done, darling!"
echo "Total files: $totalfiles"
echo "Total converted files: $totalconvertedfiles"
