function fish_prompt
  set -l last_status $status

  # git branch if in repository
  set -l ref (git symbolic-ref --quiet --short HEAD 2>/dev/null
              or git rev-parse --short HEAD 2>/dev/null)
  and echo -n -s (set_color --bold bryellow) "$ref " (set_color normal)

  set -l preprompt
  if set -q SSH_TTY
    set preprompt (string join "" (prompt_hostname) " ")
  end

  set -l prompt_char
  switch "$USER"
    case root toor
      set prompt_char '#'
    case '*'
      set prompt_char '>'
  end

  if test $last_status -eq 0
    echo -n -s "$preprompt$prompt_char "
  else
    echo -n -s (set_color --bold brred) "$preprompt$prompt_char " (set_color normal)
  end
end
