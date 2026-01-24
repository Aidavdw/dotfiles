if status is-interactive
    # Commands to run in interactive sessions can go here

    # Automatically start in VI mode in insert
    fish_vi_key_bindings
end



# Add current directory in file manager
abbr -a --position command exp 'xdg-open .'

# We need to run visudo as sudo, which means that it uses root's environment variables.
# So, we need to export EDITOR again.
abbr -a --position command visudo 'sudo EDITOR=vim visudo'
abbr -a --position command csv 'column -t'
abbr -a --position command nvimdiff 'nvim -d'
abbr -a --position command weather 'curl wttr.in'

# When we view dmesg, we probably want to look at it with pretty colors
abbr -a --position command dmesg 'sudo dmesg --color=always | less -R'

# When using journalctl, we're probably not interested in all the old stuff.
# So, only show most recent boot.
abbr -a --position command journalctl 'journalctl --b 0'
