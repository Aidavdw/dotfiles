# Specifically run hyprland on the igpu.
# This will be set by the udev rules.
# Then set GL vendor etc to make sure all apps start on igpu
# except if explicitly called with prime-run
# libva driver is the intel VA-API.
AQ_DRM_DEVICES=/dev/dri/intel-igpu __GLX_VENDOR_LIBRARY_NAME=mesa LIBVA_DRIVER_NAME=iHD Hyprland

