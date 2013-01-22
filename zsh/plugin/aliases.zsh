
#
# .zsh/topics/aliases.zsh
# aliases that don't fit into any topic
#

alias diff="colordiff"
alias grep="grep --color=auto"

alias df="df -hT --total"
alias dfc="dfc -sTt -rootfs,devtmpfs,tmpfs"
alias du="du -ch"

alias rm="rm -I"

alias c6="chmod 600"
alias c7="chmod 700"
alias px="chmod +x"
alias pnx="chmod -x"

alias d="dirs -v"
alias j="jobs -l"

alias v="gvim"
alias vv="gvim --remote-silent"

alias tm="tmux new"
alias ta="tmux attach"
alias tl="tmux ls"

alias uumount="udiskie-umount 2> /dev/null"
alias weechat="tmux new -s weechat weechat-curses"
alias t="todo.sh"

# pastebin sprunge.us (<command> | sprunge)
alias sprunge="curl -F 'sprunge=<-' http://sprunge.us"

# find out own ip
alias myip="lynx -dump tnx.nl/ip"

# convert decimal to/from hex
alias d2h='printf "%x\n" $1'
alias h2d='printf "%d\n" 0x$1'


if [[ $EUID != 0 ]];then
	alias poweroff="sudo poweroff"
	alias reboot="sudo reboot"
fi

# vim:set sw=4 foldmethod=marker ft=zsh:
