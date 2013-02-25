
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
        alias mutt="tmux neww -t 9 -c ~/down -d -n mail ~/bin/mutt"
    fi

fi
