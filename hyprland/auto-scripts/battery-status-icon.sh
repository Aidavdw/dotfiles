#!/usr/bin/env bash
# Depending on how full the battery is, it returns a different icon as text:

# Detect if AC power is connected
charging=false
for ac in /sys/class/power_supply/AC* /sys/class/power_supply/ADP*; do
    if [[ -e "$ac/online" ]] && [[ "$(cat "$ac/online")" == "1" ]]; then
        charging=true
        break
    fi
done

# If charging, show charging icon
if $charging; then
    echo ""
    exit 0
fi

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
