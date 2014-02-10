
#
# .zsh/decisions.zsh
# help me decide
#

if which shuf &>/dev/null; then
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
fi

# source: http://www.reddit.com/r/commandline/comments/1kubou/some_help_naming_your_web_site/
alias sitenamr="grep '[^aeiou]er$' /usr/share/dict/words | shuf -n 1 | sed -r -e 's.er$.r.' -e 's.^(\w).\u\1.'"
