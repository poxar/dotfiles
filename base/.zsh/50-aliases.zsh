
#
# .zsh/50-aliases.zsh
# aliases that don't fit into any topic
#

alias grep="grep $grep_options"

which colordiff &>/dev/null && \
    alias diff="colordiff"

alias df="df -hT"
alias dff="df -x tmpfs -x devtmpfs"
alias dfl="dff -l"
alias du="du -ch"
alias dus="du -s"

alias rm="rm -I"

alias cpx="chmod +x"
alias cmx="chmod -x"

alias d="dirs -v"
alias j="jobs -l"

# auto sudo
alias poweroff="$SUDO poweroff"
alias reboot="$SUDO reboot"
