
#
# .zsh/10-prompt.zsh
#

PROMPT=""
# hostname in white, only if ssh-ed into a machine
[[ -n $SSH_CLIENT ]] && PROMPT+="%B%m%b "
# prompt character; red # if root, white > else
PROMPT+="%B%0(#.%F{red}#%f.>)%b "

RPROMPT=""
# number of running background jobs in green if >0
RPROMPT+="%1(j.[%F{green}%j%f].)"
# pwd in blue
RPROMPT+=" %B%F{blue}%~%f%b"

# echo return code in red if !=0
precmd() {
  last_cmd=$?
  [[ $last_cmd -ne 0 ]] && echo -e "\e[01;31m$last_cmd\e[00m"
  unset last_cmd
}
