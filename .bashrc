#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export EDITOR=vim

alias grep='grep --color=auto'

# Use eza instead of ls, as it has many more features.
alias ls='eza -al --color=always --group-directories-first'
alias tree='eza --color=always --group-directories-first --tree -L 3'

# lf: Terminal file explorer like ranger. This to set it up so that it exits into the directory you're currently in


lfcd () {                                             
# `command` is needed in case `lfcd` is aliased to
cd "$(command lf -print-last-dir "$@")"
}
    
# Also set a keybind to open it with <ctrl>+<o>
bind '"\C-o":"\C-ulfcd\C-m"'

# The user@hostname part that is printed before every command. If starship is installed use that, otherwise use a fallback
if [ -x "$(command -v starship)" ]; then
    eval "$(starship init bash)"
else
    echo 'starship unavailable, using PS1 for current session' >&2
    export PS1='\e[01;32m[\t]\e[m \u@\h \e[0;32m\w\e[m$ '
fi


# 'oh fuck, I needed to run that command as sudo'. Rerun the previous command as sudo
alias please='sudo "$BASH" -c "$(history -p !!)"'

# Extra path directories: Rust programs, own scripts, and local bin programs.
PATH="$HOME/.cargo/bin${PATH:+:${PATH}}"
PATH="$HOME/.local/bin${PATH:+:${PATH}}"
PATH="$HOME/scripts${PATH:+:${PATH}}"
