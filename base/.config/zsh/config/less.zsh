# don't save history
export LESSHISTFILE=/dev/null

# -F quit-if-one-screen
# -M (very) long prompt
# -R show color escapes
# -X don't clear the screen on exit
export LESS='-F -M -R -X'

# use lesspipe or lesspipe.sh, whatever is available
if (( $#commands[(i)lesspipe(|.sh)] )); then
  export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
fi

