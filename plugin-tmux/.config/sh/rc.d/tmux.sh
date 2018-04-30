alias ta="tmux attach"
alias tl="tmux ls"
alias tu="tmux-up"

tm() {
  if _pd_check tmux-up; then
    tmux-up "$HOME/.tmux/std.conf"
  else
    tmux new -s std
  fi
}
