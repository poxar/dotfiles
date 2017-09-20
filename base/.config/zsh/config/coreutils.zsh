# apply default flags
test -n "$cp_options"   && alias cp="cp $cp_options"
test -n "$mv_options"   && alias mv="mv $mv_options"
test -n "$ls_options"   && alias ls="ls -vh $ls_options"
test -n "$grep_options" && alias grep="grep $grep_options"
test -n "$grep_options" && alias egrep="egrep $grep_options"
test -n "$grep_options" && alias fgrep="fgrep $grep_options"

alias l="ls"
alias la="ls -A"
alias sul="sudo ls -A $ls_options"
alias lg="ls -hal | grep -iI -D skip --color=auto"

# ls only (dot)dirs
alias lad='l -d -- .*(/)'
alias ld='l -d -- *(/)'
# ls only (dot)files
alias laf='l -a -- .*(.)'
alias lf='l -a -- *(.)'

alias df="df -hT -x tmpfs -x devtmpfs"
alias dfc="dfc -d -t -rootfs,tmpfs,devtmpfs,autofs"

alias du="du -ch"

alias d="dirs -v"
alias j="jobs -l"
alias h="history"

alias bc="bc -ql"

# colorful diff
which colordiff &>/dev/null && \
    alias diff="colordiff"

