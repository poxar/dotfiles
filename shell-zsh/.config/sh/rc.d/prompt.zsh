precmd() {
  # echo return code in red if !=0
  last_cmd=$?
  [[ $last_cmd -ne 0 ]] && echo -e "\e[01;31m$last_cmd\e[00m"
  unset last_cmd
  set-prompt $KEYMAP
}

# use a function to set the prompt according to the mode we're in
set-prompt() {
  PS1=""
  # hostname in white, only if ssh-ed into a machine
  [[ -n $SSH_CLIENT ]] && PS1+="%m "
  # prompt character
  # insert/emacs mode: red # if root, white > else
  # command mode: red #: if root, white : else
  if [[ $1 == "vicmd" ]]; then
    PS1+="%B%0(#.%F{red}#:%f.:)%b "
  else
    PS1+="%B%0(#.%F{red}#%f.>)%b "
  fi

  # just prepend the parser status (function, for, while, etc)
  PS2="%_ $PS1"

  RPS1=""
  # number of running background jobs in green if >0
  RPS1+="%1(j.[%F{green}%j%f].)"
  # pwd in blue (restricted to the last two directories)
  RPS1+=" %B%F{blue}%2~%f%b"
  # git branch in yellow if available
  ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0
  RPS1+=" %B%F{yellow}${ref#refs/heads/}%f%b"
}

# change the prompt on mode-switch
function zle-line-init zle-keymap-select {
  set-prompt $KEYMAP
  zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

# set the prompt now
set-prompt
