function fish_prompt
  set -l last_status $status
  set -l prompt_char

  # path
  if test $PWD != $HOME
    echo -n (basename $PWD)
  end

  # indicate if we are in a distrobox
  if test -n "$CONTAINER_ID"
    set -a prompt_char '📦'
  end

  # indicate ssh
  if test -n "$SSH_CLIENT"
    set -a prompt_char '󰖟 '
  end

  # the prompt character
  if fish_is_root_user
    set -a prompt_char '#'
  else
    set -a prompt_char '➜'
  end

  # make the prompt char(s) red if the last command failed
  if test $last_status -eq 0
    echo -n -s " $prompt_char "
  else
    echo -n -s (set_color --bold red) " $prompt_char " (set_color normal)
  end
end
