
#
# .zsh/10-prompt.zsh
#

### first line
PROMPT=" "
# hostname in white
PROMPT+="%B%m %b"
# pwd in blue
PROMPT+="%B%F{blue}%~%f%b"
# return code in red if != 0
PROMPT+="%(?.. [%B%F{red}%?%f%b])"
# number of running background jobs if >0
PROMPT+="%1(j. (%F{green}%j%f).)"

### second line
PROMPT+="
 "
# prompt character; red # if root, white > else
PROMPT+="%B%0(#.%F{red}#%f.>)%b "

