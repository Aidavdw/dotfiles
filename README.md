Hello! these are my dotfiles (program configurations). Feel free to steal :)
They are mosty organised by program, though there are some that work in tandem, so they are put together.
I use stow, so expect all files in named directories to be relative to `~`.

# Modules

## .outside
These are **not** stow files! These are to be placed outside of the `~` dir.
It contains a couple things:
- udev rules to write a temporary marker file when power shaving is enabled
- Desktop files for Hyprland wayland sessions running on specific GPUs.
Both have installers.

## bat
Like `cat`, but syntax-highlighted.

## beeper
A matrix bridging client that allows you to use whatsapp, signal etc. from a single client.
Requires `beeper-bin` from the AUR.

## blink
Very cute little minimal break timer.
get it [here](https://github.com/rijkvp/blink).
```bash
cd ~/read-only-repos/
git clone https://github.com/rijkvp/blink
cd blink
cargo build --release
```

Requires input tracking to be done by root.
After building, run `./blink/.outside/install.sh`




## btop
TUI tool for showing cpu usage etc.

## covenience-scripts
Contains a whole bunch of scripts that are useful to be able to run directly from the terminal.


## engineering-scripts
Tools for engineering tasks that I do often. Doubt these are going to be useful to anyone but me lol.

## fcitx5-wayland
Input method, set up for wayland (used for hyprland)
Contains config files for other programs to ensure they launch in a way that fcitx can access them too.

## fonts
My fontconfig prefences.

## ghostty
Terminal emulator

## go
Settings for goland

## hunspell
command-line spell checker

## Hyprland
The meat of my hyprland setup.
Expects you to run a nvidia/intel igpu combo.
Requires quite most of the other modules:
- fcitx5-wayland
- convenience_scripts
- waybar
- swaync
- satty

and the following packages:
```bash
pacman -S \
hyprland \
hyprutils \
hyprpolkitagent \
xdg-desktop-portal-hyprland \
hypridle \
hyprlock \
pipewire \
swww \
gnome-keyring \
```

## JOSM
open street map editor

## kodi-cli
Simple script that allows you to send stuff to kodi
Instead of stowing, just run the installer script..
`~/.kodirc` must have the password of the user that kodi is run as on the other machine in cleartext.
Change where it says `<password>` to the password of the user you run kodi as.

## latex
science documents.

## matplotlib
Standard plotting styles

## mpd
Music player with server-client architecture.
```bash
pacman -S \
mpd \
mpc \ # simple command-line client, useful for scripting
mpd-mpris \ # Allows you to use MPRIS / play/pause using playerctl
rmpc \ # like ncmpcpp, but prettier
mpdscribble \ # lastfm scrobbler
playerctl
```

After stowing:
Config file requires a password, so you need to manually set it.
```shell
cp .outside/mpdscribble.conf.example /etc/mpdscribble.conf
```
edit to use lastfm password.

## mpv
video player
```bash
pacman -S \
mpv \ 
xclip # dependency of mpvacious
```

Also requires `mpv-mpvacious` from the AUR

## nautilus
simple gui file browser

## nvim
See neovim config

## paru
AUR helper.

## qimgv
super lightweight image viewer.
install from AUR `qimgv`.

## rofi
application launcher etc

## satty
Screenshot editor

## swaync
Notification centre

## swww
Pretty backgrourds for hyprland with animations

## Terminal
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

## Vesktop
better discord client

## vim
classic text editor.

## waybar
status bar for hyprland

## zathura
super fast pdf viewer with vim keybinds



# Currently unused:

## dunst
Wayland notification manager
replaced by swaync

## kde-pim
akonadi etc, email clients from kde.
Curretly using evolution.

## kitty
terminal emulator
replaced by ghostty

## nchat
TUI whatsapp and telegram client.
replaced by beeper.

## obsidian
PKM. Notes etc.
Currently just using nvim.

## papis
python reference manager.
Replaced by nvim+bibcite, jabref

## quickshell
pretty desktop.
Never got the time to set this up

## safeeyes
forces you to take breaks

## thunar
file manager.
Using nautilus now.

## vscode
code editor.
nvim now.

## zed
code editor
using nvim now.
