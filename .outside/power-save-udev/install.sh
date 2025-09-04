#!/bin/bash
set -euo pipefail

# Ensure running with root for system-wide install
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root (use sudo)" >&2
    exit 1
fi

# Paths
USER_HOME=$(eval echo "~$SUDO_USER")
DOTFILES="$USER_HOME/dotfiles/.outside/power-save-udev"
BIN_DIR="/etc/udev/rules.d"


echo "Installing power saving trigger. Be sure you have stowed the power save scripts."

# Install wrapper scripts with explicit .sh extension
install -m 0755 "$DOTFILES/90-power-save.rules" "$BIN_DIR/90-power-save.rules"

# enable & restart udev
udevadm control --reload-rules
udevadm trigger --subsystem-match=power_supply
