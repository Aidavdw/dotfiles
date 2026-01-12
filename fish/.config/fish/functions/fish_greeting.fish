function fish_greeting --description 'What is displayed every time you first open the terminal'
    # If khal is installed, show the schedule
    if type -q khal
        echo Schedule:
        khal list now +2d
        echo -------------------------------------------------
    else
        echo fish session: (set_color yellow)$USER(set_color normal)@(set_color blue)$hostname(set_color normal) 
    end
end
