# Use yazi to interactively cd.
# If that's not installed, try lf.
# If that's not installed, try ranger.

function lfcd --description 'Run lf and cd to the selected directory'
    set -l dir (command lf -print-last-dir $argv)
    if test -n "$dir"
        cd "$dir"
    end
end

# https://yazi-rs.github.io/docs/quick-start/#shell-wrapper
function yazicd --description 'Run yazi and cd to the selected directory'
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	command yazi $argv --cwd-file="$tmp"
	if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
    stty sane
end


if status is-interactive
    if type -q yazi
        bind \co 'yazicd; commandline -f repaint'
        bind -M insert \co 'yazicd; commandline -f repaint'
    else if type -q lf
        bind \co 'lfcd; commandline -f repaint'
        bind -M insert \co 'lfcd; commandline -f repaint'
    end
end
