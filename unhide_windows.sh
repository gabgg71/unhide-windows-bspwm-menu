#!/usr/bin/env bash

# Author  : Gabriela Galindo
# Applets : Unhide windows

theme="arthur"
prompt='Unhide window: '
efonts="JetBrains Mono Nerd Font 10"

desktop=$(xdotool get_desktop)
minimized=$(xdotool search --all --desktop ${desktop} "" 2>/dev/null | grep -vF "$(xdotool search --all --onlyvisible --desktop ${desktop} "" 2>/dev/null)" | xargs -I % sh -c 'echo -n "% | "; xdotool getwindowname %')


rofi_cmd() {	
	rofi -theme-str "element-text {font: \"$efonts\";}" \
			-dmenu -format i:s -i \
			-p "$prompt" \
			-mesg "$mesg" \
			-theme ${theme}
}

run_rofi() {
	echo -e "$(echo "${minimized}" | awk -F '|' '{print $NF}')" | rofi_cmd
}

chosen="$(run_rofi)"
if [ -n "$chosen" ]; then
	pos=$(($(echo "${chosen}" | awk -F ':' '{print $1}') +1 ))
	id=$(echo "$minimized" | sed -n "${pos}p" | awk -F '|' '{print $1}') 
    bspc node ${id} -g hidden=off
	bspc node ${id} -f
fi


