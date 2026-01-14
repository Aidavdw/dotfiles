#!/usr/bin/env bash
# Hyprland does not have a way to immediately reload the images.
# This is shitty for displaying album art.
# Also do not want to have to reload it every 0.5 seconds.
# So instead, immediately send SIGUSR2, which immediately reloads stuff.
hyprlock --grace 5 &
(
    sleep 0.2
    pkill --signal USR2 hyprlock
)
