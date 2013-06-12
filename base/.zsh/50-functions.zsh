
#
# .zsh/functions.zsh
# functions, that don't fit into any topic
#

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

# fast cd ..
function up {
  local dir
  for parent in {1..${1:-1}}; do
    dir=../$dir
  done
  builtin cd $dir
}

# witty one-liners

# convert nfo files to utf8
nfo() { iconv -f 437 -t UTF8 "$@" | ${PAGER:-less} }

# grep the history
hist() { fc -fl -m "*(#i)$1*" 1 | grep -i $grep_options $1 }

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

# convert decimal to/from hex
d2h() { printf "%x\n" $* }
h2d() { printf "%d\n" $* } # 0x

# base64
encode64(){ echo -n $1 | base64 }
decode64(){ echo -n $1 | base64 -d }
