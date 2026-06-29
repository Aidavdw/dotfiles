#!/bin/bash
# Usage: play-if-not-dnd.sh /path/to/sound.ogg

if [[ $(swaync-client -D) == "false" ]]; then
    pw-play "$1"
fi
