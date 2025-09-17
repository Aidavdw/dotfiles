# It should automatically get the nvidia GPU.
# Setting it explicitly here makes the primary screen be stuck at the TTY.
# AQ_DRM_DEVICES=/dev/dri/nvidia-gpu Hyprland
# and then recommended flags by hyprland wiki for nvidia GPU
# https://wiki.hypr.land/Nvidia/
LIBVA_DRIVER_NAME=nvidia __GLX_VENDOR_LIBRARY_NAME=nvidia Hyprland
