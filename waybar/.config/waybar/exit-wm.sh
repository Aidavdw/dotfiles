#!/usr/bin/env bash

# Used in case you somehow mess up your keybinds, so that you can still launch it from waybar.

session=""

handle_hyprland() {
    hyprctl dispatch exit
}

handle_niri() {
    niri msg action quit
}

# Detect session via env vars (fast path)
for var in "$XDG_CURRENT_DESKTOP" "$XDG_SESSION_DESKTOP" "$DESKTOP_SESSION"; do
    case "$var" in
    *[Hh]yprland*)
        session="hyprland"
        break
        ;;
    *[Nn]iri*)
        session="niri"
        break
        ;;
    esac
done

# Fallback detection (only if needed)
if [[ -z "$session" ]]; then
    if pgrep -x Hyprland >/dev/null; then
        session="hyprland"
    elif pgrep -x niri >/dev/null; then
        session="niri"
    fi
fi

# Dispatch cleanly
case "$session" in
hyprland)
    handle_hyprland
    ;;
niri)
    handle_niri
    ;;
*)
    notify-send "cannot determine if you are in niri or hyprland :("
    ;;
esac
