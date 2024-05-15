#!/bin/bash

echo Setting up Aida\'s dotfiles
# Stow creates a symlinked version of all these files in their respective directories!
stow .


# The folder-changing script for `lf` is not automatically set to be executable, so using ctrl-o will give an error that lfcd is not found.
chmod +x ~/.config/lf/lfcd.sh

echo "Dotfiles fully set up!"
