# Use eza instead of ls.
# Can show colours and icons.
function __eza_base
    command eza --color=always --group-directories-first --icons=automatic $argv
end

abbr -a --position command ls   '__eza_base'
abbr -a --position command tree '__eza_base --tree -L 3'
abbr -a --position command ll   '__eza_base -l --git --octal-permissions'
abbr -a --position command la   '__eza_base -a'
abbr -a --position command lla  '__eza_base -la --octal-permissions'

abbr -a --position command ls 'eza --color=always --group-directories-first --icons=automatic'
abbr -a --position command tree 'eza --color=always --group-directories-first --tree -L 3'
abbr -a --position command ll 'eza -l --color=always --group-directories-first --icons=automatic --git --octal-permissions'
abbr -a --position command la 'eza -a --color=always --group-directories-first --icons=automatic'
abbr -a --position command lla 'eza -la --color=always --group-directories-first --icons=automatic --octal-permissions'

bind \ch 'echo ls;__eza_base; commandline -f repaint'
bind -M insert \ch 'echo ls;__eza_base; commandline -f repaint'
