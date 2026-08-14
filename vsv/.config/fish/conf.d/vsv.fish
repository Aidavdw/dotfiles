# vsv -u has hardcoded that it expects the user-services at ~/runit/services.
# void's runit has it by default at ~/.config/service/
abbr -a --position command usv 'vsv -d ~/.config/service/'
