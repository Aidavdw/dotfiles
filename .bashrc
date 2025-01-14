#!/bin/bash
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Default programs
export EDITOR=vim
export VISUAL=vim
export BROWSER=firefox

alias grep='grep --color=auto'

# Use eza instead of ls, as it has many more features.
alias ls='eza -al --color=always --group-directories-first'
alias tree='eza --color=always --group-directories-first --tree -L 3'

# do visudo with vim, without having to edit root's bashrc
alias visudo='sudo EDITOR=vim visudo'

# Running 'vscodium ignores ~/.config/codium-flags.conf, which makes it not run with ime flags. This ensures it is never ignored'. https://github.com/VSCodium/vscodium/issues/1966
alias vscodium='codium'

# lf: Terminal file explorer like ranger. This to set it up so that it exits into the directory you're currently in
lfcd () {
    # `command` is needed in case `lfcd` is aliased to.
    # -print-last-dir requires lf version > 30 (debian Bookworm is v28). If using such an old version, see https://github.com/gokcehan/lf/blob/7d47436a352eb7f7d61303045ed79ed8989c6270/etc/lfcd.sh
    cd "$(command lf -print-last-dir "$@")" || exit
}

# Also set a keybind to open lf with <ctrl>+<o>
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

# When connecting to a live usb, ssh might complain about an invalid hosts file if you have previously connected to that device (but not with the USB). Use this to connect then.
alias archusb-ssh='ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no"'

# Catppuccin Mocha colour theme for FZF
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
# Make fzf include hidden files be default. Also ignore .git folder. Magic invocation stolen from https://github.com/junegunn/fzf/issues/337#issuecomment-977592444 
export FZF_DEFAULT_COMMAND='find . \! \( -type d -path ./.git -prune \) \! -type d \! -name '\''*.tags'\'' -printf '\''%P\n'\'

# automatically fill in the 'cd' if you type in just a directory name.
shopt -s autocd

# Vim mode in terminal!
set -o vi
bind '"tn":vi-movement-mode'

# Extra path directories: Rust programs, own scripts, and local bin programs.
PATH=$PATH:"$HOME/.cargo/bin:$HOME/.local/bin:$HOME/scripts:$HOME/os/eww/target/release"
