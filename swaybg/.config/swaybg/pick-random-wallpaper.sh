#!/bin/sh

WALLPAPER_DIR="$HOME/.config/swaybg/random_wallpapers"

# Pick a random regular file.
WALLPAPER="$(find -L "$WALLPAPER_DIR" -type f -print0 |
    shuf -z -n 1 | tr -d '\0')"

if [ -z "$WALLPAPER" ]; then
    notify-send \
        --urgency=critical \
        --app-name="swaybg" \
        "swaybg" \
        "No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

exec swaybg -i "$WALLPAPER" -m fill
