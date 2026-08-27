# The '-f' in `shutdown -f now` is not 'force'.
# Also, `shutdown` normally freezes runit, so just always say 'halt'
abbr -a --position command shutdown 'sudo shutdown -h now'
abbr -a --position command reboot 'sudo reboot'
