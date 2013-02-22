
#
# .zsh/topics/decisions.zsh
# help me decide
#

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

# vim:set sw=4 foldmethod=marker ft=zsh:
