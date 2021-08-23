function fish_prompt
  set -l last_status $status

  # replace $HOME with ~
  set -l my_pwd (string replace -r '^'$HOME'($|/)' '~$1' $PWD)
  # reduce to the last two path components
  set -l pwd_paths (string split -r / $my_pwd)
  set my_pwd (string join '/' $pwd_paths[-2..])
  # add the result to the prompt
  echo -n -s (set_color brblue) "$my_pwd " (set_color normal)

  # git branch if in repository
  set -l ref (git symbolic-ref --quiet --short HEAD 2>/dev/null
              or git rev-parse --short HEAD 2>/dev/null)
  and echo -n -s (set_color --bold bryellow) "$ref " (set_color normal)

  # hostname if connected via ssh
  if set -q SSH_TTY
    echo -n -s (prompt_hostname)' '
  end

  # the prompt character
  set -l prompt_char
  switch "$USER"
    case root toor
      set prompt_char '#'
    case '*'
      set prompt_char '❯'
  end

  # double prompt character if in nix shell
  if test -n "$IN_NIX_SHELL"
    set prompt_char $prompt_char$prompt_char
  end

  # make the prompt char(s) red if the last command failed
  if test $last_status -eq 0
    echo -n -s "$prompt_char "
  else
    echo -n -s (set_color --bold brred) "$prompt_char " (set_color normal)
  end
end
