function fish_prompt
  set -l last_status $status

  # hostname if connected via ssh
  if set -q SSH_TTY
    echo -n -s ' '(prompt_hostname)
  end

  # working directory
  # replace $HOME with ~
  set -l my_pwd (string replace -r '^'$HOME'($|/)' '~$1' $PWD)
  # reduce to the last two path components
  set -l pwd_paths (string split -r / $my_pwd)
  set my_pwd (string join '/' $pwd_paths[-2-1])
  # add the result to the prompt
  echo -n -s (set_color brblue) "$my_pwd" (set_color normal)

  # git info if in repository
  set -x __fish_git_prompt_showcolorhints 1
  set -x __fish_git_prompt_color_branch --bold bryellow
  set -x __fish_git_prompt_color_branch_detached --bold brred
  set -x __fish_git_prompt_use_informative_chars 1
  set -x __fish_git_prompt_char_stateseparator ' '
  set -x __fish_git_prompt_showstashstate 1
  fish_git_prompt " %s"

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
