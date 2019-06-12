# be colorful
CLICOLOR=1
export CLICOLOR

# ask if override is ok
cp_options="-i $cp_options"
mv_options="-i $mv_options"

alias df='df -T nodevfs,autofs'
alias bc='bc -ql'

export LC_CTYPE='en_US.UTF-8'
export LANG='en_US.UTF-8'
