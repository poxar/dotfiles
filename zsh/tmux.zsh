
#
# .zsh/plugin/tmux.zsh
#

alias tm="tmux new"
alias ta="tmux attach"
alias tl="tmux ls"

# only alias these in a running tmux session
if [[ ! -z $TMUX ]]; then
  alias weechat="tmux neww -t 0 -d -n chat weechat-curses"
fi
