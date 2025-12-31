function fish_prompt --description 'Write out the prompt'
    # We save the exit code of the previous command so we can display it.
    # This includes single commands, but also ones that are chained in pipes.
    set -l last_pipestatus $pipestatus
    set -lx __fish_last_status $status # Export for __fish_print_pipestatus.

    set -q fish_color_status
    or set -g fish_color_status red


    # Write pipestatus
    # If the status was carried over (if no command is issued or if `set` leaves the status untouched), don't bold it.
    set -l bold_flag --bold
    set -q __fish_prompt_status_generation; or set -g __fish_prompt_status_generation $status_generation
    if test $__fish_prompt_status_generation = $status_generation
        set bold_flag
    end
    set __fish_prompt_status_generation $status_generation
    set -l status_color (set_color $fish_color_status)
    set -l statusb_color (set_color $bold_flag $fish_color_status)
    set -l prompt_status (__fish_print_pipestatus "[" "]" "|" "$status_color" "$statusb_color" $last_pipestatus)


    # TODO: Add fallback for if we do not have a nerd font.
    set -l color_cwd $fish_color_cwd
    set -l suffix '❯'



    # Colour the prompt differently when we're root
    if functions -q fish_is_root_user; and fish_is_root_user
        if set -q fish_color_cwd_root
            set color_cwd $fish_color_cwd_root
        end
        set suffix '#'
    end

    # If we are on the local machine, do not display hostname.
    # If displaying hostname, always have leading `@`
    if set -q SSH_CONNECTION; or set -q SSH_TTY
        set -l p_host @(set_color green)$hostname(set_color normal)
    else
        set -l p_host ""
    end

    # If we are on SSH, display user and hostname.
    # Also hide the username if it's $default_user
    set user ""
    if test "$USER" != "aida"
        set p_user (set_color red)$USER(set_color normal)
    else
        set p_user ""
    end

    # NOTE: If `aida@this_machine`, it will be empty.

    #echo "$p_user$p_host"


    # Display the current time
    set -l clock (date "+[%H:%M]")

    # If the previous command took longer than 3 seconds to complete,
    # show how long it took to complete in seconds (1 decimal).
    set -l p_time_elapsed ""
    if test $CMD_DURATION -gt 3000
        set -l seconds (math -s1 "$CMD_DURATION/1000")
        set p_time_elapsed (set_color blue)"[$seconds"s"]"(set_color normal)
    end

    # Display VI mode if we are not in insert mode.
    # Also show blocks etc. Might be default configured already.

    # Transient prompt: Only show pwd and command.
    # Filter out invalid commands.

    set -l reset_color (set_color normal)
    echo -n -s "$p_user$p_host" (set_color $color_cwd) (prompt_pwd) (set_color blue) (fish_vcs_prompt) (set_color normal) $p_time_elapsed $prompt_status $suffix " "
end
