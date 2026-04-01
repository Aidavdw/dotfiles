#!/usr/bin/env bash

session=""

handle_hyprland() {
    if hyprctl clients | grep -q "title: impala"; then
        hyprctl dispatch focuswindow "title:impala"
    else
        hyprctl dispatch 'exec [float] alacritty -e impala'
    fi
}

handle_niri() {
    local win_id

    win_id=$(niri msg -j windows | jq -r '.[] | select(.title == "impala") | .id' | head -n1)

    if [[ -n "$win_id" && "$win_id" != "null" ]]; then
        niri msg action focus-window --id "$win_id"
    else
        niri msg action spawn -- "alacritty" "--title" "impala" "-e" "impala"
    fi
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
