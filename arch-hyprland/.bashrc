#!/bin/bash
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Set some things that are specific to the hyprland/arch install


# use the customisation from the `bash` package
if [-f ~/.bashrc_universal]; then
    . ~/bashrc_universal
else
    echo "`bash` package not stowed from dotfiles. Pretty sure you might wanna do this!"
fi
