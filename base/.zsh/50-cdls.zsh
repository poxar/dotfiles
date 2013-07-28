
#
# .zsh/50-cdls.zsh
# aliases and functions for cd, ls, mkdir
#

alias ls="ls $ls_options"
alias l="ls -lhFB"
alias la="ls -lAhB"
alias md="mkdir -p"

# ls only (dot)dirs
alias lad='l -d -- .*(/)'
alias ld='l -d -- *(/)'
# ls only (dot)files
alias laf='l -a -- .*(.)'
alias lf='l -a -- *(.)'

if [[ ! -z $PROJECTS ]]; then
    c() { $PROJECTS/$1 }
    compdef "_path_files -/ -W $PROJECTS" c
fi

# cd to directory and list files
cdl() { cd $1 && l }
# create dir(s) and cd to the first one
mcd() { mkdir -p $@ && cd $1 }

# ls in less
if ls --help 2> /dev/null | grep -q GNU; then
  ll() { ls -lAhB --color=always "$@" | less -r }
else
  ll() { ls -lAhB "$@" | less }
fi

# count the files/folders in a directory
lc() { ls "$@" | wc -l }
# count (almost) all
lca() { ls -A "$@" | wc -l }

# create a dir in tmp and cd to it
cdtmp() {
    local t
    t=$(mktemp $mktemp_options -d)
    echo $t
    builtin cd $t
}

# show a diff of two dirs
diffdir() {
    local DIR1_TMP
    local DIR2_TMP
    DIR1_TMP=$(mktemp $mktemp_options)
    DIR2_TMP=$(mktemp $mktemp_options)

    ls -a $1 > $DIR1_TMP
    ls -a $2 > $DIR2_TMP

    if which colordiff &>/dev/null; then
        colordiff $DIR2_TMP $DIR1_TMP
    else
        diff $DIR2_TMP $DIR1_TMP
    fi

    rm -f $DIR1_TMP $DIR2_TMP
}

# go up to the first parent directory matching $1
# http://www.reddit.com/r/commandline/comments/1j7y16/handy_bash_function_i_just_wrote_to_move_up/
up() {
    echo $(pwd)
    if [[ $1 == "" ]]; then
        newdir=/
    else
        local newdir=$(dirname $(pwd))
    fi

    while [[ "$(basename $newdir)" != *$1* ]] && [[ "$(basename $newdir)" != "/" ]]
    do
        newdir=$(dirname $newdir)
    done

    echo $newdir
    cd $newdir
}
