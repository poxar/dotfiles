
#
# .zsh/topics/functions.zsh
# functions, that don't fit into any topic
#

# witty one-liners

# convert nfo files to utf8
nfo() { iconv -f 437 -t UTF8 "$@" | $PAGER }

# grep the history
hist() { fc -fl -m "*(#i)$1*" 1 | grep -i --color $1 }

# download album from imgur
imgur() { curl "$1" | grep _blank | awk '{print $2}' | cut -d \" -f 2 | xargs wget }

# make decisions
# flip a coin
yn(){
    print -n "thinking"
    for i in {1..4}; do
	print -n "."
	sleep 0.3
    done
    shuf -n 1 -e 'Yes!' 'No!'
}

# give a "random" line from file $1
decide(){
    if [[ -f $1 ]]; then
	print -n "thinking"
	for i in {1..4}; do
	    print -n "."
	    sleep 0.3
	done
	print "" # newline
	shuf -n 1 $1
    else
	print 'there is nothing to decide!'
    fi
}


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

# vim:set sw=4 foldmethod=marker ft=zsh:
