if status is-interactive
    # Commands to run in interactive sessions can go here

    # Automatically start in VI mode in insert
    fish_vi_key_bindings
end

function fish_greeting
    echo (set_color yellow)$USER(set_color normal)@(set_color blue)$hostname(set_color normal) fish session
end


# Add current directory in file manager
abbr -a --position command exp 'xdg-open .'

# We need to run visudo as sudo, which means that it uses root's environment variables.
# So, we need to export EDITOR again.
abbr -a --position command visudo 'sudo EDITOR=vim visudo'
abbr -a --position command csv 'column -t'
abbr -a --position command nvimdiff 'nvim -d'
abbr -a --position command weather 'curl wttr.in'
