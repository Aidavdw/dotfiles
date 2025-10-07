# It should automatically get the nvidia GPU.
# Setting it explicitly here makes the primary screen be stuck at the TTY.
# AQ_DRM_DEVICES=/dev/dri/nvidia-gpu Hyprland
# and then recommended flags by hyprland wiki for nvidia GPU
# https://wiki.hypr.land/Nvidia/
# Don't need to set __EGL_CENDOR_LIBRARY_FILENAMES and VK_ICD_FILENAMES, as the nvidia gpu is turned on anyway. Doesn't save waking it up.
LIBVA_DRIVER_NAME=nvidia \
__GLX_VENDOR_LIBRARY_NAME=nvidia \
Hyprland
