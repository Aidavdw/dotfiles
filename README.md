# dotfiles

Install (and update) by running `~/scripts/stow-dotfiles`

Move `.outside/mpdscribble.conf.example` to `/etc/mpdscribble.conf` Change (remove .example)
`~/mpdscribble/mpdscribble.conf.example` to use lastfm password.

# Recommended programs

These programs are set up using these dotfiles, or required.

```bash
pacman -S
xdg-user-dirs # utility to handle setting $XDG_DOWNLOADS_DIR etc.
eza # like 'ls', but with nicer colored output
lf # ranger, but better. allows you to cd really quickly
starship # Makes terminal header line pretty instead of ugly PS1 var
fzf # fuzzy file finder
btop # is a resource manager/task manager like `top` but with much more info and pretty colours
kitty # terminal emulator
p7zip # command line 7zip
wget # for downloading from web
bat # cat, but with syntax highlighting, git, etc.
alsa-utils # Contains aplay, which is very useful for playing notification sounds.
gtk3 # Otherwise blackscreens Hyprland
qt5-wayland # Library to allow qt5 apps to run in wayland, I think? Suggested by hyprland wiki
qt6-wayland # dito
hyprland hyprutils hyprlang hyprwayland-scanner # Including supporting libraries. Be sure not to mix git and non-git!
hyprlock # lockscreen
hyprpicker # color picker
hypridle #
hyprcursor # SVG based cursor, which means it scales
waybar # Toolbar
mpd mpc ncmpcpp # music player daemon, for playing music
stow # For managing dotfiles
arch-install-scripts # To be able to create a new arch install image from here- includes arch-chroot
fcitx5 # input method, so IME can be used
fcitx5-mozc # for Japanese input
firefox # mah internetz
fuzzel # Program launcher. Can be left out if using rofi.
github-cli # To authorise git with github
mpv # media player.
pavucontrol # Simple audio selection and volume control. works with pipewire through pipewire-pulse
swaync # notifications daemon
pacman-contrib # Pacman scripts, including paccache.timer
thunar thunar-media-tags-plugin thunar-volman # file manager
thunar-archive-plugin xarchiver # Allows archives to be opened in thunar. plugin requires a backend, for which I like xarchiver.
qualc # Terminal calculator
swww # Wallpapers
imagemagick # command line image editor, used for scripting wallpapers.
xdg-desktop-portal xdg-desktop-portal-wlr # To enable screensharing in wayland. Might be replaced by xdg-desktop-portal-hyprland
xdg-desktop-portal-hyprland # To enable screensharing in wayland
socat # To make scripts that hook into hyprland IPC sockets (such as changing wallpaper on workspace change)
shotcut # Video editor
util-linux # Various utilities: SSD trim
hunspell # command line spell checker
deluge # torrent client
gimp # image editor
xclip # Dependency of mpv-mpvacious
audacity # Audio editor
cowsay # moo
digikam # picture management software
kid3 # music metadata tagger
restic # Backup tool
syncthing # Peer-to-peer syncing of files
signal-desktop # messenger
zathura zathura-pdf-mupdf # Lightweight pdf viewer
yt-dlp # Command line youtube downloader
xorg-xlsclients # allows use of xlsclients command, which shows which programs are running in xwayland.
ripgrep-all # Faster grep, that also allows searching in pdfs etc. Used in fzf wrapper script.
papirus-icon-theme # icons used kinda everywhere.
wl-clipboard cliphist # Clipboard manager. Requires rofi to work well.
wtype # xdotool for wayland. Allows simulating keypresses. Used in clipboard + rofi automation.
noto-fonts-emoji # Proper display of emoji. Required for rofimoji
rofimoji # Emoji picker
python-build # Enables building python projects from pyproject.toml etc. using python -m build
grim # utility to take screenshots on wayland. Required by flameshot.


paru -S
qimgv # Image viewer
cantata-qt6 # music player
mpd-mpris-bin # To allow playerctl to control mpd
vscodium-bin # Code editor
vscodium-bin-marketplace # Easier installing extensions
webcord-bin # Electron wrapped alternative client for discord, as this one does allow to screenshare.
python-ics # used in 'today-calendar' widget
freetube # YouTube client
safeeyes # Forces me to take lil breaks
aylurs-gtk-shell # Widget engine that is better than EWW. Not used yet.
betterbird-bin # Fork of thunderbird mailclient. Better.
nordvpn-bin # vpn
mpv-mpvacious # Plugin for mpv that allows you to generate anki cards sentence mining.
mpd-mpris-bin # To allow playerctl to control mpd
flameshot-git # To take screenshots.
```
