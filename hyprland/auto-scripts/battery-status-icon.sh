#!/usr/bin/env bash
# Depending on how full the battery is, it returns a different icon as text:

# Get battery percentage as an integer
battery="$("$HOME/scripts/battery-percentage")"

if ((battery > 78)); then
    echo ""
elif ((battery < 20)); then
    echo ""
elif ((battery < 35)); then
    echo ""
elif ((battery < 60)); then
    echo ""
else
    # 60–78%
    echo ""
fi
