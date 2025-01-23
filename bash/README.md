Use me to get a pretty and functional terminal!
Deliberately not a `~/.bashrc`, because that would break using this on some distros that put a lot of info in their bashrc.
Extends .bashrc. Should be automatically loaded if you use the `arch-hyprland` package. If loading this on another distro, be sure to put the following snippet into your `~/.bashrc`
```bash
# use the customisation from the `bash` package
if [-f ~/.bashrc_universal]; then
    . ~/bashrc_universal
else
    echo "`bash` package not stowed from dotfiles. Pretty sure you might wanna do this!"
fi
```
