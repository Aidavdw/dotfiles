# It should automatically get the nvidia GPU.
# Setting it explicitly here makes the primary screen be stuck at the TTY.
# AQ_DRM_DEVICES=/dev/dri/nvidia-gpu Hyprland
# and then recommended flags by hyprland wiki for nvidia GPU
# https://wiki.hypr.land/Nvidia/
# Don't need to set __EGL_CENDOR_LIBRARY_FILENAMES and VK_ICD_FILENAMES, as the nvidia gpu is turned on anyway. Doesn't save waking it up.
#
# See this lil guide too:
# https://gist.github.com/kRHYME7/1d2574e8f3a4b7ad4059535503ce1eaa

# AQ_FORCE_LINEAR_BLIT=0
# Do not force linear modifiers on multi-gpu buffers.
# source: https://wiki.hypr.land/Nvidia/#multi-gpu-or-hybrid-graphics-not-working-for-monitors-attached-to-nvidia-gpu

# AQ_DRM_DEVICES=/dev/dri/nvidia-gpu
# Run aquamarine (hyprland backend) on dgpu
# source: wiki

# NVD_BACKEND=direct
# Use VA_API hardware video acceleration.
# This requires nvidia-vaapi-driver (installed as libva-nvidia-driver on arch)

# LIBVA_DRIVER_NAME=nvidia
# Use hardware acceleration for nvidia
LIBVA_DRIVER_NAME=nvidia \
    __GLX_VENDOR_LIBRARY_NAME=nvidia \
    AQ_DRM_DEVICES=/dev/dri/nvidia-gpu \
    AQ_FORCE_LINEAR_BLIT=0 \
    LIBVA_DRIVER_NAME=nvidia \
    GBM_BACKEND=nvidia-drm \
    NVD_BACKEND=direct \
    start-hyprland
