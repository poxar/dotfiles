function fish_prompt
  set -l last_status $status

  # cwd
  echo -n (prompt_pwd)

  # hostname if connected through ssh
  if test -n "$SSH_CLIENT"
    echo -n " $(hostname -f)"
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
end
