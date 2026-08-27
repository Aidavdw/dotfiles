#!/bin/sh

usage() {
    echo "Usage: $0 <action> [--if-not-playing-music] [--if-not-plugged-in]"
    echo
    echo "Actions:"
    echo "  hibernate      Hibernate the computer"
    echo "  sleep          Put the computer to sleep"
    echo "  lock           Lock the session"
    echo "  dim            Dim the display"
    echo "  monitor-off    Turn off the monitors"
}

if [ "$#" -lt 1 ]; then
    usage >&2
    exit 2
fi

action=$1
shift

if_not_playing=0
if_not_plugged_in=0

case "$action" in
hibernate | sleep | lock | dim | monitor-off)
    ;;
*)
    echo "Unknown action: $action" >&2
    usage >&2
    exit 2
    ;;
esac

while [ "$#" -gt 0 ]; do
    case "$1" in
    --if-not-playing-music)
        if_not_playing=1
        ;;
    --if-not-plugged-in)
        if_not_plugged_in=1
        ;;
    *)
        echo "Unknown option: $1" >&2
        usage >&2
        exit 2
        ;;
    esac
    shift
done

if [ "$if_not_playing" -eq 1 ]; then
    if mpc status | grep -q playing; then
        exit 1
    fi
fi

if [ "$if_not_plugged_in" -eq 1 ]; then
    found_power_supply=0

    for online in /sys/class/power_supply/*/online; do
        [ -f "$online" ] || continue
        found_power_supply=1

        if [ "$(cat "$online")" = 1 ]; then
            exit 1
        fi
    done

    # No power-supply entries means we cannot establish that
    # this is a battery-powered laptop, so treat it as plugged in.
    if [ "$found_power_supply" -eq 0 ]; then
        exit 1
    fi
fi

case "$action" in
hibernate)
    sudo zzz -Z
    ;;
sleep)
    ~/scripts/run-with-fallback 'loginctl lock-session' 'veila lock'
    ~/scripts/run-with-fallback 'sudo zzz -z' 'sudo systemctl suspend'
    ;;
lock)
    ~/scripts/run-with-fallback 'loginctl lock-session' 'veila lock'
    ;;
dim)
    brightnessctl -s set 10
    ;;
monitor-off)
    ~/scripts/run-with-fallback 'niri msg action power-off-monitors' 'hyprctl dispatch dpms off'
    ;;
esac
