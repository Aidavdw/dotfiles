# Terminal
Terminal goodies for shortcuts, SSH keys.
Contains a modular bashrc. 
Deliberately not a `~/.bashrc`, because that would break using this on some distros that put a lot of info in their bashrc.
If loading this on another distro, be sure to put the following snippet into your `~/.bashrc`
```
# Load sub files as managed in dotfiles in `.bashrc.d` folder.
[ -d ~/.bashrc.d ] && for f in ~/.bashrc.d/*.sh; do . "$f"; done

```

And similar for `bash_profile`:
```
# Load sub files as managed in dotfiles in `.bash_profile.d` folder.
[ -d ~/.bash_profile.d ] && for f in ~/.bash_profile.d/*.sh; do . "$f"; done
```

## Required programs
```
fzf # fuzzy file finder
eza # modern ls replacement
yazi # modern ranger replacement (terminal file browser)
```

## Recommended programs
If using bash, `starship` is nice. On most other package managers available as `curl -sS https://starship.rs/install.sh | sh` 
