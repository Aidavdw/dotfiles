# Use eza instead of ls.
# Can show colours and icons.

alias ls="eza --color=always --group-directories-first --icons=automatic"

abbr -a --position command tree 'ls --tree -L 3'
abbr -a --position command ll   'ls -l --git --octal-permissions --header'
abbr -a --position command la   'ls -a'
abbr -a --position command lla  'ls -la --git --octal-permissions --header'

bind \ch 'echo ls;ls; commandline -f repaint'
bind -M insert \ch 'echo ls;ls; commandline -f repaint'
