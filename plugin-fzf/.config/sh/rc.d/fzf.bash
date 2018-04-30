__rl_fzf() {
  local args
  args=$(__fzf_fsel)

  local lbuffer=${READLINE_LINE:0:$READLINE_POINT}
  local rbuffer=${READLINE_LINE:$READLINE_POINT}

  test -n "$args" && lbuffer+="$args"

  READLINE_LINE="$lbuffer$rbuffer"
  READLINE_POINT="${#lbuffer}"
}

bind -m emacs -x '"\e ":"__rl_fzf"'
bind -m vi-command -x '" ":"__rl_fzf"'

bind -m emacs '"\e\\":"\C-e\C-u cd $(__fzf_dsel)\C-m"'
bind -m vi-command '"\\":"cc cd $(__fzf_dsel)\C-m"'
