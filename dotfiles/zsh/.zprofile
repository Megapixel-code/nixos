#!/usr/bin/env bash
autoload -Uz compinit

# Use XDG dirs for completion and history files

[ -d "$XDG_STATE_HOME"/zsh ] || mkdir -p "$XDG_STATE_HOME"/zsh
HISTFILE="$XDG_STATE_HOME"/zsh/history

[ -d "$XDG_CACHE_HOME"/zsh ] || mkdir -p "$XDG_CACHE_HOME"/zsh
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME"/zsh/zcompcache
compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-"$ZSH_VERSION"

# have wofi drun look at $HOME/desktop for desktop apps
desktop_dir="$HOME/desktop"

mkdir -p "$desktop_dir"/applications
rm -f "$desktop_dir"/applications/*

desktopfiles=("${(@f)$(ls "$desktop_dir"/*.desktop)}")
for e in "${desktopfiles[@]}"; do
  ln -sfn "$e" "$desktop_dir/applications"
done

export XDG_DATA_DIRS="$desktop_dir:$XDG_DATA_DIRS"
