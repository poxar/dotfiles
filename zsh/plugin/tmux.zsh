
#
# .zsh/plugin/tmux.zsh
#

if which tmux &>/dev/null; then

  alias tm="tmux new"
  alias ta="tmux attach"
  alias tl="tmux ls"

  # only alias these in a running tmux session
  if [[ ! -z $TMUX ]]; then
    alias weechat="tmux neww -t 0 -d -n chat weechat-curses"
    if which mutt &>/dev/null && \
      which imap &>/dev/null
    then
      alias mail="tmux neww -t 9 -c ~/down -d -n mail mutt && \
        tmux split -dl 4 -t mail.1 imap && \
        tmux resize-pane -Z -t mail.1"
    fi
  fi
fi
