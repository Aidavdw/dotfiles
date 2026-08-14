#!/bin/bash
set -euo pipefail

# Ensure running with root for system-wide install
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root (use sudo)" >&2
    exit 1
fi

# Paths
USER_HOME=$(eval echo "~$SUDO_USER")
DOTFILES="$USER_HOME/dotfiles/.outside/wayland-sessions"
BIN_DIR="/usr/local/bin"
SESSIONS_DIR="/usr/share/wayland-sessions"


echo "Installing Hyprland session scripts and desktop files..."

install -m 0755 "$DOTFILES/hyprland-igpu.sh" "$BIN_DIR/"
install -m 0755 "$DOTFILES/hyprland-nvidia-gpu.sh" "$BIN_DIR/"
install -m 0644 "$DOTFILES/hyprland-igpu.desktop" "$SESSIONS_DIR/"
install -m 0644 "$DOTFILES/hyprland-nvidia-gpu.desktop" "$SESSIONS_DIR/"
install -m 0644 "$DOTFILES/tty-session.desktop" "$SESSIONS_DIR/"
install -m 0755 "$DOTFILES/niri-void-session.sh" "$BIN_DIR/"
install -m 0644 "$DOTFILES/niri-void.desktop" "$SESSIONS_DIR/"

echo "Done. You should now see the new Hyprland sessions in your greeter."

