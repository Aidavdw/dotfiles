# Use yazi to interactively cd.
# If that's not installed, try lf.
# If that's not installed, try ranger.

function lfcd --description 'Run lf and cd to the selected directory'
    set -l dir (command lf -print-last-dir $argv)
    if test -n "$dir"
        cd "$dir"
    end
end

function yazicd --description 'Run yazi and cd to the selected directory'
    set -l tmp (mktemp -t yazi-cwd.XXXXXX)

    yazi $argv --cwd-file="$tmp"

    if test -f "$tmp"
        set -l cwd (string trim -- (cat "$tmp"))
        if test -n "$cwd" -a "$cwd" != "$PWD"
            cd "$cwd"
        end
        rm -f "$tmp"
    end
end


if status is-interactive
    if type -q yazi
        bind \co 'yazicd'
    else if type -q lf
        bind \co 'lfcd'
    end
end
