function fish_right_prompt --description 'Displays current mode in the right'
switch $fish_bind_mode
    case default
      set_color --bold red
      echo '[N] '
    case insert
    case replace_one
      set_color --bold green
      echo '[R] '
    case replace
      set_color --bold bryellow
      echo '[R] '
    case visual
      set_color --bold brmagenta
      echo '[V] '
    case '*'
      set_color --bold red
      echo '[?] '
  end
  set_color normal
end
