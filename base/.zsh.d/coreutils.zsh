
#
# .zsh/50-coreutils.zsh
#

# apply default flags
test -n $cp_options && alias cp="cp $cp_options"
test -n $mv_options && alias mv="mv $mv_options"
test -n $ls_options && alias ls="ls $ls_options"

alias l="ls -vh"
alias la="ls -vhA"
alias sul="sudo ls -vhA $ls_options"

# ls only (dot)dirs
alias lad='l -d -- .*(/)'
alias ld='l -d -- *(/)'
# ls only (dot)files
alias laf='l -a -- .*(.)'
alias lf='l -a -- *(.)'

alias df="df -hT -x tmpfs -x devtmpfs"
alias dfc="dfc -t -rootfs,tmpfs,devtmpfs,autofs"

alias du="du -ch"

alias d="dirs -v"
alias j="jobs -l"
alias h="history"

alias bc="bc -ql"

# colorful diff
which colordiff &>/dev/null && \
    alias diff="colordiff"

# quick cd to project directories
if [[ ! -z $PROJECTS ]]; then
    c() { builtin cd $PROJECTS/$1 }
    compdef "_path_files -/ -W $PROJECTS" c
fi

autoload cdtmp
autoload man
autoload up

# witty one-liners

# quick find
ff() { find . -name "$*" }

# count the files/folders in a directory
lc() { ls "$@" | wc -l }
# count (almost) all
lca() { ls -A "$@" | wc -l }

# search in zshall(1)
zman() { PAGER="less -g -s '+/^       "$1"'" man zshall }

# convert nfo files to utf8
nfo() { iconv -f 437 -t UTF8 "$@" | ${PAGER:-less} }

# grep the history
hist() { fc -fl -m "*(#i)$1*" 1 | grep -i $grep_options $1 }

