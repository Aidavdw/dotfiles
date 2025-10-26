#!/bin/bash
# ~/.bashrc
#

# Default programs
export EDITOR=vim
export VISUAL=vim
export BROWSER=firefox

alias grep='grep --color=auto'

# Use eza instead of ls, as it has many more features.
alias ls='eza --color=always --group-directories-first --icons=automatic'
alias tree='eza --color=always --group-directories-first --tree -L 3'
alias ll='eza -l --color=always --group-directories-first --icons=automatic --git --octal-permissions'
alias la='eza -a --color=always --group-directories-first --icons=automatic'
alias lla='eza -la --color=always --group-directories-first --icons=automatic --octal-permissions'

# do visudo with vim, without having to edit root's bashrc
alias visudo='sudo EDITOR=vim visudo'

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Running 'vscodium ignores ~/.config/codium-flags.conf, which makes it not run with ime flags. This ensures it is never ignored'. https://github.com/VSCodium/vscodium/issues/1966
alias vscodium='codium'

# Add current directory in file manager
alias exp='xdg-open .'

# lf: Terminal file explorer like ranger. This to set it up so that it exits into the directory you're currently in
lfcd() {
    # `command` is needed in case `lfcd` is aliased to.
    # -print-last-dir requires lf version > 30 (debian Bookworm is v28). If using such an old version, see https://github.com/gokcehan/lf/blob/7d47436a352eb7f7d61303045ed79ed8989c6270/etc/lfcd.sh
    cd "$(command lf -print-last-dir "$@")" || exit
}

function yazicd() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# set a keybind to open yazi with ctrl+o.
# If yazi is unavailable, fall back to lf.
if [ -x "$(command -v yazi)" ]; then
    bind '"\C-o":"\C-uyazicd\C-m"'
elif [ -x "$(command -v lf)" ]; then
    bind '"\C-o":"\C-ulfcd\C-m"'
else
    echo "neither yazi nor lf available, can't ctrl-o."
fi

# Keybind to open lazygit with ctrl+g
bind '"\C-g":"\C-ulazygit\C-m"'

# Keybind to open nvim in the current dir with ctrl+n
bind '"\C-n":"\C-unvim .\C-m"'

# Keybind to open neovide in the current dir with ctrl+h
bind '"\C-h":"\C-uneovide --size=1920x1080 . &\C-m"'

# The user@hostname part that is printed before every command. If starship is installed use that, otherwise use a fallback
if [ -x "$(command -v starship)" ]; then
    eval "$(starship init bash)"
else
    # Nobody tells you that you need to enclose colour codes with \[ \] (also ending \[\e[00m\], because otherwise it starts overwriting the current line.
    export PS1='\n[\[\e[01;32m\]\A\[\e[00m\] \u@\h] \[\e[32m\]\w\[\e[00m\]\n\[\e[30;107m\]$\[\e[00m\] '
fi

# 'oh fuck, I needed to run that command as sudo'. Rerun the previous command as sudo
alias please='sudo "$BASH" -c "$(history -p !!)"'
alias kut='sudo "$BASH" -c "$(history -p !!)"'

# When connecting to a live usb, ssh might complain about an invalid hosts file if you have previously connected to that device (but not with the USB). Use this to connect then.
alias archusb-ssh='ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no"'

alias csv='column -t'

alias nvimdiff='nvim -d'

# Catppuccin Mocha colour theme for FZF
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
# Make fzf include hidden files be default. Also ignore .git folder. Magic invocation stolen from https://github.com/junegunn/fzf/issues/337#issuecomment-977592444
export FZF_DEFAULT_COMMAND='find . \! \( -type d -path ./.git -prune \) \! -type d \! -name '\''*.tags'\'' -printf '\''%P\n'\'

# automatically fill in the 'cd' if you type in just a directory name.
shopt -s autocd

# You have to open ssh-agent and ssh-add manually all the time.
# Use small program 'keychain' to do it for you if it is installed
# Right now defer this to gnome-keychain.
# if [ -x "$(command -v keychain)" ]; then
    # Assumes you store your ssh key with the default name.
#    eval 'keychain --eval id_ed25519'
# else
#    echo \'keychain\' is not installed, you\'ll have to manually start ssh-agent and add ssh keys.
# fi

# Make the prompt asking for your password when using sudo red.
export SUDO_PROMPT="$(tput setaf 1 bold)Password:$(tput sgr0) "

# Extra path directories: Rust programs, own scripts, and local bin programs.
PATH=$PATH:"$HOME/.cargo/bin:$HOME/.local/bin:$HOME/scripts:$HOME/os/eww/target/release"
