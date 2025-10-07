# Specifically run hyprland on the igpu.
# Also set up every other program to launch under the igpu,
# unless specifically started using the dgpu with e.g. prime-run
# or my own wrapper script.
# Then set GL vendor etc to make sure all apps start on igpu
# except if explicitly called with prime-run

# Which specific gpu device to run hyprland on.
# the device is a symlink to the igpu, set up from udev rules. 
# (see the other modules in this git)
export AQ_DRM_DEVICES=/dev/dri/intel-igpu
# OpenGL: used by hyprland itself too!
export __GLX_VENDOR_LIBRARY_NAME=mesa
# libva driver is the intel VA-API.
export LIBVA_DRIVER_NAME=iHD
export VDPAU_DRIVER=va_gl

export KWIN_DRM_DEVICES=/dev/dri/intel-igpu

# Attempt at stopping apps from activating the dgpu for like 5 seconds
# from https://bbs.archlinux.org/viewtopic.php?pid=2098846#p2098846
# Extended with my own findings, already put on arch wiki.
# These must be overwritten when you try to run something on the nvidia gpu!
export __EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/50_mesa.json
# For nvidia: /usr/share/glvnd/egl_vendor.d/10_nvidia.json
export VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/intel_icd.x86_64.json
# For nvidia: /usr/share/vulkan/icd.d/nvidia_icd.json


Hyprland

