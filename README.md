# Terminal
Terminal goodies for shortcuts, SSH keys.
Contains a modular bashrc. 
Deliberately not a `~/.bashrc`, because that would break using this on some distros that put a lot of info in their bashrc.
If loading this on another distro, be sure to put the following snippet into your `~/.bashrc`
```bash
# use the customisation from the `bash` package
if [ -f ~/.bashrc_universal ]; then
    . ~/.bashrc_universal
else
    echo "`bash` package not stowed from dotfiles. Pretty sure you might wanna do this!"
fi
```
## Required programs
```
fzf # fuzzy file finder
eza # modern ls replacement
yazi # modern ranger replacement (terminal file browser)
```
## Recommended programs
If using bash, `starship` is nice. On most other package managers available as `curl -sS https://starship.rs/install.sh | sh` 
