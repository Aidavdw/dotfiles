#!/usr/bin/env bash

# Path to the runtime status file
GPU_STATUS_FILE="/sys/bus/pci/devices/0000:01:00.0/power/runtime_status"

# Read current status
if [ ! -f "$GPU_STATUS_FILE" ]; then
    echo "{\"text\": \"\", \"tooltip\": \"GPU status file not found\"}"
    exit 1
fi

STATUS=$(cat "$GPU_STATUS_FILE")

# Choose symbol and tooltip based on status
if [[ "$STATUS" == "active" ]]; then
    SYMBOL="󰍹"
    COLOR="#F38BA8"
    TOOLTIP="NVIDIA GPU Active"
else
    SYMBOL=""
    COLOR="#94E2D5"
    TOOLTIP="NVIDIA GPU Suspended. All apps running on iGPU"
fi

# Output JSON for Waybar
echo "{\"text\": \"$SYMBOL\", \"tooltip\": \"$TOOLTIP\", \"class\": \"$STATUS\", \"percentage\": 0, \"alt\": \"$STATUS\", \"color\": \"$COLOR\"}"
