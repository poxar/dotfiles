alias ta="tmux attach"
alias tl="tmux ls"
alias tu="tmux-up"

tm() {
  if command -v tmux-up >/dev/null; then
    tmux-up $HOME/.tmux/std.conf
  else
    alias tm="tmux new -s std"
  fi
}
