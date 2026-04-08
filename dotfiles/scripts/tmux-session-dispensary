#!/usr/bin/env bash
# https://github.com/SylvanFranklin/.config/blob/main/scripts/tmux-session-dispensary.sh

# colors:
black=0
red=1
green=2
yellow=3
blue=4
magenta=5
cyan=6
white=7
bright_black=8
bright_red=9
bright_green=10
bright_yellow=11
bright_blue=12
bright_magenta=13
bright_cyan=14
bright_white=15

SK_THEME=(
	--color=none,fg:"$white",hl:"$red",fg+:"$black",bg+:"$red",hl+:"$bright_white",current_match_bg:"$red",info:"$white",prompt:"$red",cursor:"$black"
	--margin=25%
	--prompt="λ "
)

DIRS=(
	"$HOME/"
	"$HOME/documents/"
	"$HOME/documents/projects/"
)

if [[ $# -eq 1 ]]; then
	selected=$1
else
	selected=$(find "${DIRS[@]}" -maxdepth 1 -mindepth 1 -type d -not -path "*/.*" \
		| sed "s|^$HOME/||" \
		| sk "${SK_THEME[@]}")

	[[ $selected ]] && selected="$HOME/$selected"
fi

[[ ! $selected ]] && exit 0

selected_name=$(basename "$selected" | tr . _)

if ! tmux has-session -t "$selected_name"; then
	tmux new-session -ds "$selected_name" -c "$selected"
	tmux select-window -t "$selected_name:1"
fi

tmux switch-client -t "$selected_name"
