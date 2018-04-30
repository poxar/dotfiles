__prompt() {
  last_status=$?

  local reset='\[\e(B\e[m\]'
  local bold='\[\e[1m\]'
  local red='\[\e[31m\]'

  local host
  host=$(test -n "$SSH_CLIENT" && echo '\h ')

  local prompt="$bold"
  if test $EUID -eq 0; then
    color+="$red# "
  else
    color+="> "
  fi

  PS1="$host$prompt$reset"

  if test "$last_status" -gt 0; then
    PS1="$bold$red$last_status$reset\\n$PS1"
  fi

  export PS1
}

export PROMPT_COMMAND='__prompt'
