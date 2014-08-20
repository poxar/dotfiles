# change the prompt on mode-switch
function zle-line-init zle-keymap-select {
  set-prompt $KEYMAP
  zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

# echo return code in red if !=0
function precmd() {
  last_cmd=$?
  [[ $last_cmd -ne 0 ]] && echo -e "\e[01;31m$last_cmd\e[00m"
  unset last_cmd
  set-prompt $KEYMAP
}

# use a function to set the prompt according to the mode we're in
function set-prompt() {
  PS1=""
  # hostname in white, only if ssh-ed into a machine
  [[ -n $SSH_CLIENT ]] && PS1+="%B%m%b "
  # prompt character
  # insert/emacs mode: red # if root, white > else
  # command mode: red : if root, white : else
  if [[ $1 == "vicmd" ]]; then
    PS1+="%B%0(#.%F{red}:%f.:)%b "
  else
    PS1+="%B%0(#.%F{red}#%f.>)%b "
  fi

  # just prepend the parser status (function, for, while, etc)
  PS2="%_ $PS1"

  RPS1=""
  # number of running background jobs in green if >0
  RPS1+="%1(j.[%F{green}%j%f].)"
  # pwd in blue
  RPS1+=" %B%F{blue}%~%f%b"
}

# set the prompt now
set-prompt
