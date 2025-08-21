#!/bin/bash
set -euo pipefail

# Paths
USER_HOME=$(eval echo "~$SUDO_USER")
DOTFILES="$USER_HOME/dotfiles/.outside/wayland-sessions"
BIN_DIR="/usr/local/bin"
SESSIONS_DIR="/usr/share/wayland-sessions"

# Ensure running with root for system-wide install
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root (use sudo)" >&2
    exit 1
fi

echo "Installing Hyprland session scripts and desktop files..."


# Install wrapper scripts with explicit .sh extension
install -m 0755 "$DOTFILES/hyprland-igpu.sh" "$BIN_DIR/hyprland-igpu.sh"
echo " -> Installed wrapper: $BIN_DIR/hyprland-igpu.sh"

install -m 0755 "$DOTFILES/hyprland-nvidia-gpu.sh" "$BIN_DIR/hyprland-nvidia-gpu.sh"
echo " -> Installed wrapper: $BIN_DIR/hyprland-nvidia-gpu.sh"

# install -m 0755 "$DOTFILES/hyprland-powersave.sh" "$BIN_DIR/hyprland-powersave.sh"
# echo " -> Installed wrapper: $BIN_DIR/hyprland-powersave.sh"

# Install desktop files explicitly
install -m 0644 "$DOTFILES/hyprland-igpu.desktop" "$SESSIONS_DIR/hyprland-igpu.desktop"
echo " -> Installed session: $SESSIONS_DIR/hyprland-igpu.desktop"

install -m 0644 "$DOTFILES/hyprland-nvidia-gpu.desktop" "$SESSIONS_DIR/hyprland-nvidia-gpu.desktop"
echo " -> Installed session: $SESSIONS_DIR/hyprland-nvidia-gpu.desktop"

#install -m 0644 "$DOTFILES/hyprland-powersave.desktop" "$SESSIONS_DIR/hyprland-powersave.desktop"
#echo " -> Installed session: $SESSIONS_DIR/hyprland-powersave.desktop"

echo "Done. You should now see the new Hyprland sessions in your greeter."

