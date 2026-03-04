# Add current directory in file manager
abbr -a --position command exp 'xdg-open .'

# We need to run visudo as sudo, which means that it uses root's environment variables.
# So, we need to export EDITOR again.
abbr -a --position command visudo 'sudo EDITOR=vim visudo'
abbr -a --position command csv 'column -t'
abbr -a --position command nvimdiff 'nvim -d'
abbr -a --position command weather 'curl wttr.in'

# When we view dmesg, we probably want to look at it with pretty colors
abbr -a --position command dmesg 'sudo dmesg --color=always | less -R'

# When using journalctl, we're probably not interested in all the old stuff.
# So, only show most recent boot.
abbr -a --position command journalctl 'journalctl --b 0'

# GREP by default is case-sensitive.
# Whenever we look for stuff manually, we probably want to find all.
abbr -a grep 'grep -i'

# -R – the RAW_CONTROL_CHARS, can therefore show colours.
# -i – searches within less are case-insensitive
# -X – don’t clear the screen after using less
# -j5 – put the result of searches on the fifth line of the screen where possible
abbr -a less "less -RiXj5"
