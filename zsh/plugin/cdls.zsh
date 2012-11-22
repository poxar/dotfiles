
#
# .zsh/topics/cdls.zsh
# aliases and functions for cd, ls, mkdir
#

PROJECTS="$HOME/code"

alias ls="ls --color=auto"
alias l="ls -lhFB"
alias la="ls -lAhB"
alias md="mkdir -p"

# ls only (dot)dirs
alias lad='l -d -- .*(/)'
alias ld='l -d -- *(/)'
# ls only (dot)files
alias laf='l -a -- .*(.)'
alias lf='l -a -- *(.)'

c() { $PROJECTS/$1 }
compdef "_path_files -/ -W $PROJECTS" c
h() { $HOME/$1 }
compdef "_path_files -/ -W $HOME" h
u() { ~dropbox/Uni/$1 }
compdef "_path_files -/ -W ~dropbox/Uni" u

# cd to directory and list files
cdl() { cd $1 && l }
# create dir(s) and cd to the first one
mcd() { mkdir -p $@ && cd $1 }

# colorful ls in less
ll() { ls -lAhB --color=always "$@" | less -r }

# count the files/folders in a directory
lc() { ls "$@" | wc -l }
# count (almost) all
lca() { ls -A "$@" | wc -l }

# create a dir in tmp and cd to it
cdtmp() {
    local t
    t=$(mktemp -d)
    echo $t
    builtin cd $t
}

# show a diff of two dirs
diffdir() {
    DIR1_TMP=$(mktemp)
    DIR2_TMP=$(mktemp)

    ls -a $1 > $DIR1_TMP
    ls -a $2 > $DIR2_TMP

    colordiff $DIR2_TMP $DIR1_TMP
    rm -f $DIR1_TMP $DIR2_TMP
}
