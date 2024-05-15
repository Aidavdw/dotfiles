#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export EDITOR=vim

alias grep='grep --color=auto'

# The user@hostname part that is printed before every command.

# Use eza instead of ls, as it has many more features.
alias ls='eza -al --color=always --group-directories-first'
alias tree='eza --color=always --group-directories-first --tree -L 3'

# lf: Terminal file explorer like ranger. This to set it up so that it exits into the directory you're currently in
LFCD="~/.config/lf/lfcd.sh"
if [ -f "$LFCD" ]; then
    source "$LFCD"
fi
# Also set a keybind to open it with <ctrl>+<o>
bind '"\C-o":"lfcd\C-m"'

# Make the terminal look pretty using starship! Means that PS1 does not need to be set.
#PS1='[\u@\h \W]\$ '
eval "$(starship init bash)"

# 'oh fuck, I needed to run that command as sudo'. Rerun the previous command as sudo
alias please='sudo "$BASH" -c "$(history -p !!)"'

# Extra path directories: Rust programs, own scripts, and local bin programs.
PATH="$HOME/.cargo/bin${PATH:+:${PATH}}"
PATH="$HOME/.local/bin${PATH:+:${PATH}}"
PATH="$HOME/.dotfiles/scripts${PATH:+:${PATH}}"
