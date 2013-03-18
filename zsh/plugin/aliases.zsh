
#
# .zsh/plugin/aliases.zsh
# aliases that don't fit into any topic
#

alias grep="grep $grep_options"

which colordiff &>/dev/null && \
    alias diff="colordiff"

alias df="df -chT"
alias du="du -ch"
alias dus="du -s"

which dfc &>/dev/null && \
    alias dfc="dfc -sTt -rootfs,devtmpfs,tmpfs"

alias rm="rm -I"

alias cpx="chmod +x"
alias cmx="chmod -x"

alias d="dirs -v"
alias j="jobs -l"

alias v="gvim"
alias vv="gvim --remote-silent"

alias t="todo.sh"

# auto sudo
alias poweroff="$SUDO poweroff"
alias reboot="$SUDO reboot"
