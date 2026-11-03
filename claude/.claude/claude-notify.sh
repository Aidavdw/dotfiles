#!/usr/bin/env bash
# Claude Code notification hook (Notification, Stop, StopFailure, UserPromptSubmit).
# Reads the hook JSON on stdin and decides whether a desktop notification is worth sending.
#
# - Skips everything while the terminal running this session is the focused window.
# - Stop: shows the gist of Claude's final message instead of a bare "Done".
# - One notification per session: new ones replace old ones (dunst stack tag / swaync sync hint).
# - Clicking the notification focuses the terminal (Hyprland or niri).
# - Submitting a new prompt dismisses that session's pending notification.
# - CLAUDE_NOTIFY_DEBUG=1 logs every hook payload to $state_dir/debug.jsonl.

set -u
input=$(cat)
j() { jq -r "$1 // empty" <<<"$input"; }

event=$(j .hook_event_name)
session=$(j .session_id)
cwd=$(j .cwd)
project=$(basename "${cwd:-${CLAUDE_PROJECT_DIR:-claude}}")

state_dir="${XDG_RUNTIME_DIR:-/tmp}/claude-notify"
mkdir -p "$state_dir"
state="$state_dir/${session:-unknown}"

[[ "${CLAUDE_NOTIFY_DEBUG:-0}" == 1 ]] && jq -c '. + {logged_at: now|todate}' <<<"$input" >>"$state_dir/debug.jsonl"

dismiss() {
    [[ -f "$state.id" ]] || return 0
    gdbus call --session --dest org.freedesktop.Notifications \
        --object-path /org/freedesktop/Notifications \
        --method org.freedesktop.Notifications.CloseNotification "$(head -n1 "$state.id")" >/dev/null 2>&1
    rm -f "$state.id"
}

# PID of the terminal emulator hosting this session: walk up the process tree.
terminal_pid() {
    local pid=$PPID comm
    while [[ "$pid" -gt 1 ]]; do
        comm=$(<"/proc/$pid/comm")
        [[ "$comm" =~ ^(alacritty|kitty|ghostty|foot|wezterm-gui)$ ]] && {
            echo "$pid"
            return
        }
        pid=$(awk '{print $4}' "/proc/$pid/stat")
    done
}

focused_pid() {
    if [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
        hyprctl activewindow -j 2>/dev/null | jq -r '.pid // empty'
    elif [[ -n "${NIRI_SOCKET:-}" ]]; then
        niri msg --json focused-window 2>/dev/null | jq -r '.pid // empty'
    fi
}

focus_terminal() {
    local pid=$1
    if [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
        hyprctl dispatch focuswindow "pid:$pid" >/dev/null
    elif [[ -n "${NIRI_SOCKET:-}" ]]; then
        local id
        id=$(niri msg --json windows | jq -r --argjson p "$pid" '.[] | select(.pid == $p) | .id' | head -n1)
        [[ -n "$id" ]] && niri msg action focus-window --id "$id"
    fi
}

# Markdown -> one short plain line (drops code blocks, markup, collapses whitespace).
summarize() {
    awk '/^```/{c=!c; next} !c && !/^#/' |
        sed -E 's/^[-*] +//; s/\*\*|__|`//g; s/\[([^]]*)\]\([^)]*\)/\1/g' |
        tr '\n' ' ' | tr -s ' ' | sed -E 's/^ //; s/ $//' | cut -c1-220
}

escape() { sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g'; }

urgency=normal
case "$event" in
UserPromptSubmit)
    dismiss
    exit 0
    ;;
Notification)
    # Only reached for the types matched in settings.json (permission, elicitation, background agent input).
    urgency=critical
    title="$(j .title)"
    body=$(j .message)
    [[ -z "$title" ]] && title="Needs your input"
    ;;
Stop)
    [[ "$(j .stop_hook_active)" == true ]] && exit 0 # a Stop hook is already continuing the turn
    prompt_id=$(j .prompt_id)
    [[ -n "$prompt_id" && -f "$state.prompt" && "$(<"$state.prompt")" == "$prompt_id" ]] && exit 0
    [[ -n "$prompt_id" ]] && echo "$prompt_id" >"$state.prompt"
    body=$(j .last_assistant_message | summarize)
    [[ -z "$body" ]] && exit 0 # nothing said, nothing to report
    urgency=low
    title="Finished"
    ;;
StopFailure)
    urgency=critical
    title="Turn failed: $(j .error)"
    body=$(j .last_assistant_message | summarize)
    ;;
*)
    exit 0
    ;;
esac

term=$(terminal_pid)
[[ -n "$term" && "$(focused_pid)" == "$term" ]] && exit 0 # you're already looking at it

dismiss
tag="claude-${session:-$project}"

# Detach: --wait blocks until the notification is clicked or closed.
export -f focus_terminal
setsid -f bash -c '
  out=$(stdbuf -oL notify-send -p --wait -a "Claude Code" -u "$1" \
        -h "string:x-dunst-stack-tag:$2" -h "string:x-canonical-private-synchronous:$2" \
        -A "default=Focus terminal" "$3" "$4" | tee "$5.id" | tail -n +2)
  rm -f "$5.id"
  [[ "$out" == default && -n "$6" ]] && focus_terminal "$6"
' _ "$urgency" "$tag" "Claude · $project — $title" "$(escape <<<"${body:-}")" "$state" "$term" \
    >/dev/null 2>&1 </dev/null

exit 0
