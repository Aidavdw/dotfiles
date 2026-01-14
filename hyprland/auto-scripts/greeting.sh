#!/usr/bin/env bash
# Prints a time-dependent greeting
#
# returns a greeting that is appropriate for the time of day.
# It should read a text file, which has entries in the following format:
# The text file can be in ~/auto-scripts/greetings.txt
#```
#7:00 11:00 = Good morning $USER
#5:00 7:00 = Up early, $USER?
#22:00 0:00 = Time for bed, $USER
#```
# The first number is the (24h clock) time when this greeting can be showed from, and the second number is when it is a valid choice until.
# If multiple options are possible, it picks one randomly.

GREETINGS_FILE="$HOME/auto-scripts/greetings.txt"

# Current time in minutes since midnight
now_minutes=$(($(date +%H) * 60 + $(date +%M)))

valid_greetings=()

while IFS= read -r line; do
    [[ -z "$line" || "$line" =~ ^# ]] && continue

    # Split line at '='
    times=${line%%=*}
    greeting=${line#*= }

    # Read start and end times
    read -r start end <<<"$times"

    start_h=${start%:*}
    start_m=${start#*:}
    end_h=${end%:*}
    end_m=${end#*:}

    start_minutes=$((start_h * 60 + start_m))
    end_minutes=$((end_h * 60 + end_m))

    if ((start_minutes < end_minutes)); then
        # Normal range
        ((now_minutes >= start_minutes && now_minutes < end_minutes)) &&
            valid_greetings+=("$greeting")
    else
        # Range wraps over midnight
        ((now_minutes >= start_minutes || now_minutes < end_minutes)) &&
            valid_greetings+=("$greeting")
    fi
done <"$GREETINGS_FILE"

if ((${#valid_greetings[@]})); then
    chosen=$(printf '%s\n' "${valid_greetings[@]}" | shuf -n 1)
else
    chosen="hello \$USER"
fi

# Expand environment variables
eval "echo \"$chosen\""
