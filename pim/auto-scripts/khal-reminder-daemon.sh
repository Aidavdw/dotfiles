#!/usr/bin/env bash
set -euo pipefail

# ---------------- configuration ----------------
KHAL="$HOME/.local/bin/khal"
REMINDERS=(60 10) # offsets in minutes
TOLERANCE=2       # allowed deviation in minutes

STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/khal-reminder"
STATE_FILE="$STATE_DIR/sent"

NOTIFY="notify-send -a $KHAL"

# Use start-time HH:MM, uid, title
KHAL_FORMAT='{start-time}|{uid}|{title}'

# ------------------------------------------------

mkdir -p "$STATE_DIR"
touch "$STATE_FILE"

now_epoch=$(date +%s)
today=$(date +%Y-%m-%d)

# Fetch today's and near-future events (up to max offset + 5 minutes)
max_offset=0
for r in "${REMINDERS[@]}"; do
    ((r > max_offset)) && max_offset=$r
done
window="+$((max_offset + 5))m"

$KHAL list now "$window" --once --format "$KHAL_FORMAT" | tail -n +2 |
    while IFS="|" read -r start_time uid title; do
        [[ -z "${start_time:-}" ]] && continue

        start_time=${start_time## } # trim leading space
        start_epoch=$(date -d "$today $start_time" +%s)
        delta_minutes=$(((start_epoch - now_epoch) / 60))

        for offset in "${REMINDERS[@]}"; do
            key="${uid}:${offset}"

            # check if reminder is within the time window and not already fired
            if ((delta_minutes <= offset)); then
                if ! grep -qxF "$key" "$STATE_FILE"; then
                    $NOTIFY \
                        "Upcoming event" \
                        "$title at $start_time (in $delta_minutes minutes)"

                    echo "$key" >>"$STATE_FILE"
                fi
            fi
        done
    done
