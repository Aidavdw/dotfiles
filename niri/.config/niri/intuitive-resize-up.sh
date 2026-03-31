#!/usr/bin/env bash

# I am just too used to how hyprland's reactive sizing.
# If it is the top one, pressing 'down' should extend it down.
# Otherwise opposite.

v_index=$(niri msg -j focused-window | jq '.layout.pos_in_scrolling_layout[1]')

# If not topmost → grow, else → shrink
if [ "$v_index" -gt 1 ]; then
    niri msg action set-window-height "+10%"
else
    niri msg action set-window-height "-10%"
fi
