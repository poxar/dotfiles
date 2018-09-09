
#
# configuration
# Basic configuration I want on all my systems and shells
#

## coreutils
# apply default flags
test -n "$cp_options"   && alias cp="cp $cp_options"
test -n "$mv_options"   && alias mv="mv $mv_options"
test -n "$ls_options"   && alias ls="ls -vh $ls_options"
test -n "$grep_options" && alias grep="grep $grep_options"
test -n "$grep_options" && alias egrep="egrep $grep_options"
test -n "$grep_options" && alias fgrep="fgrep $grep_options"

unset cp_options
unset mv_options
unset ls_options
unset grep_options

alias l="ls"
alias la="ls -A"

alias du="du -ch"

_pd_func "dirs" && alias d="dirs -v"
_pd_func "jobs" && alias j="jobs -l"
_pd_func "history" && alias h="history"

# quick cd to project directories
c() {
  cd "$PROJECTS/$*" || return 1
}

# create a dir in tmp and cd to it
cdtmp() {
  cd "$(mktemp -d /tmp/tmp.XXXXXX)" || return 1
  pwd
}

# colorful diff
_pd_check colordiff && alias diff="colordiff"


## less
alias less='less -FqX'
PAGER='less -FqX'
export PAGER

# directory listing in less
alias ll='less .'

# don't save history
LESSHISTFILE=/dev/null
export LESSHISTFILE

# don't use lesspipe
LESSOPEN=""
export LESSOPEN

# colorful man with limited width
man() {
  MANWIDTH=${MANWIDTH:-80}
  width=$(tput cols)

  [ "$width" -gt "$MANWIDTH" ] && width=$MANWIDTH
  env \
    LESS_TERMCAP_mb="$(printf "\\e[1;31m")" \
    LESS_TERMCAP_md="$(printf "\\e[1;31m")" \
    LESS_TERMCAP_me="$(printf "\\e[0m")" \
    LESS_TERMCAP_se="$(printf "\\e[0m")" \
    LESS_TERMCAP_so="$(printf "\\e[1;44;33m")" \
    LESS_TERMCAP_ue="$(printf "\\e[0m")" \
    LESS_TERMCAP_us="$(printf "\\e[1;32m")" \
    MANWIDTH="$width" \
    man "$@"

  unset width
}


## gcc
# colorful gcc
GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export GCC_COLORS
