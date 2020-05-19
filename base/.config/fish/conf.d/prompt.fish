function fish_prompt
  set -l last_status $status

  set -l prompt_char
  switch "$USER"
    case root toor
      set prompt_char '#'
    case '*'
      set prompt_char '>'
  end

  if test $last_status -eq 0
    echo -n -s "$prompt_char "
  else
    echo -n -s (set_color --bold brred) "$prompt_char " (set_color normal)
  end
end


function fish_right_prompt
  # number of background jobs if any
  if jobs -q
    echo -n -s "[" (set_color brgreen) (jobs | wc -l) (set_color normal) "] "
  end

  # current path, truncated to the last two directory segments
  set -l realhome ~
  set -l tmp (string replace -r '^'"$realhome"'($|/)' '~$1' $PWD)
  set tmp (string split -r -m2 / $tmp)

  set -l prompt_pwd
  if test -z $tmp[1]
    set prompt_pwd (string join / $tmp)
  else
    set prompt_pwd (string join / $tmp[-2..-1])
  end

  test -z $prompt_pwd; and set prompt_pwd '/'

  echo -n -s (set_color --bold brblue) "$prompt_pwd" (set_color normal)

  # git branch if in repository
  set -l ref (git symbolic-ref --quiet --short HEAD 2>/dev/null
              or git rev-parse --short HEAD 2>/dev/null)
  and echo -n -s (set_color --bold bryellow) " $ref" (set_color normal)
end
