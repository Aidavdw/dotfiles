# I almost always want to not have folders be symlinked entirely, because that places stuff back into the dotfiles.
abbr -a --position command stow 'stow --no-folding --restow'
