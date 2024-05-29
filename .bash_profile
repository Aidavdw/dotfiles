#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# QT4/5: Use fcitx for apps that bundle their own QT fcitx module
export QT_IM_MODULE=fcitx

# Set fcitx for qt > 6.7. From fcitx wiki
export QT_IM_MODULES="wayland;fcitx;ibus"

# xwayland use fcitx
export XMODIFIERS=@im=fcitx 
