# Use eza instead of ls.
# Can show colours and icons.
abbr -a --position command ls 'eza --color=always --group-directories-first --icons=automatic'
abbr -a --position command tree 'eza --color=always --group-directories-first --tree -L 3'
abbr -a --position command ll 'eza -l --color=always --group-directories-first --icons=automatic --git --octal-permissions'
abbr -a --position command la 'eza -a --color=always --group-directories-first --icons=automatic'
abbr -a --position command lla 'eza -la --color=always --group-directories-first --icons=automatic --octal-permissions'
