
#
# .zsh/50-coreutils.zsh
#

# apply standard flags
[[ -n $grep_options ]] && alias grep="grep $grep_options"
[[ -n $cp_options ]]   && alias cp="cp $cp_options"
[[ -n $mv_options ]]   && alias mv="mv $mv_options"
[[ -n $ls_options ]]   && alias ls="ls $ls_options"

alias l="ls -lhF"
alias la="ls -lAh"

# ls only (dot)dirs
alias lad='l -d -- .*(/)'
alias ld='l -d -- *(/)'
# ls only (dot)files
alias laf='l -a -- .*(.)'
alias lf='l -a -- *(.)'

alias df="df -hT"
alias dff="df -x tmpfs -x devtmpfs"
alias dfl="dff -l"
alias dffc="dfc -t -rootfs,tmpfs,devtmpfs"
alias dflc="dffc -l"

alias du="du -ch"
alias dus="du -s"

alias rm="rm -I"

alias md="mkdir -p"

alias cpx="chmod +x"
alias cmx="chmod -x"

alias d="dirs -v"
alias j="jobs -l"

# quick find
ff() { find . -name "$*" }

# be colorful
which colordiff &>/dev/null && \
    alias diff="colordiff"

# auto sudo
alias poweroff="$SUDO poweroff"
alias reboot="$SUDO reboot"

# quick cd to project directories
if [[ ! -z $PROJECTS ]]; then
    c() { $PROJECTS/$1 }
    compdef "_path_files -/ -W $PROJECTS" c
fi

# cd to directory and list files
cdl() { cd $1 && l }
# create dir(s) and cd to the first one
mcd() { mkdir -p $@ && cd $1 }

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

# quick alias / function editing (from grml.org)
# edit a function via zle
autoload zed
edfunc() {
    [[ -z "$1" ]] && { echo "Usage: edfunc <function_to_edit>" ; return 1 } || \
        zed -f "$1" ;
}
compdef _functions edfunc

# edit an alias via zle
edalias() {
    [[ -z "$1" ]] && { echo "Usage: edalias <alias_to_edit>" ; return 1 } || \
        vared aliases'[$1]' ;
}
compdef _aliases edalias

# colorful man pages
man() {
    env \
        LESS_TERMCAP_mb=$(printf "\e[1;31m") \
        LESS_TERMCAP_md=$(printf "\e[1;31m") \
        LESS_TERMCAP_me=$(printf "\e[0m") \
        LESS_TERMCAP_se=$(printf "\e[0m") \
        LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
        LESS_TERMCAP_ue=$(printf "\e[0m") \
        LESS_TERMCAP_us=$(printf "\e[1;32m") \
        man "$@"
}

# search in zshall(1)
zman() {
    PAGER="less -g -s '+/^       "$1"'" man zshall
}

# witty one-liners

# convert nfo files to utf8
nfo() { iconv -f 437 -t UTF8 "$@" | ${PAGER:-less} }

# grep the history
hist() { fc -fl -m "*(#i)$1*" 1 | grep -i $grep_options $1 }

# convert decimal to/from hex
d2h() { printf "%x\n" $* }
h2d() { printf "%d\n" $* } # 0x

# base64
encode64(){ echo -n $1 | base64 }
decode64(){ echo -n $1 | base64 -d }

# go up to the first parent directory matching $1
# http://www.reddit.com/r/commandline/comments/1j7y16/handy_bash_function_i_just_wrote_to_move_up/
up() {
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

