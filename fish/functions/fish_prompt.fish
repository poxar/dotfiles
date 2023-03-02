function fish_prompt
  set -l last_status $status

  # hostname if connected via ssh
  if set -q SSH_TTY; or set -q ET_VERSION
    echo -n -s (prompt_hostname)
  end

  # the prompt character
  set -l prompt_char
  if fish_is_root_user
    set prompt_char ' #'
  else
    set prompt_char ' ❯'
  end

  # make the prompt char(s) red if the last command failed
  if test $last_status -eq 0
    echo -n -s "$prompt_char "
  else
    echo -n -s (set_color --bold brred) "$prompt_char " (set_color normal)
  end

  # Mark the prompt for terminal applications
  echo -en "\e]133;A\e\\"
end
