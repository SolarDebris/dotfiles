#!/bin/bash

function funcReplace() {
	wallpaper=$1
	# sed -i "s/\/home\/rush\/walls.*/${wallpaper} fill/" /home/rush/.config/sway/config
	sed -i "s,/home/rush/walls/.*,/home/rush/walls/$wallpaper fill," /home/rush/.config/sway/config
	echo "Reload your Sway Config now."
}

function funcGet() {
	if [[ -z "$1" ]]; then
		echo "Input the full path to your file:"
		read -r -p "Your Path: " wallpaper
		funcReplace $wallpaper
	else
		funcReplace $1
	fi
}

funcGet $@
