
#
# zshrc
# Maintainer:	Philipp Millar <philipp.millar@gmx.de>
#

# variables {{{1
# environment {{{2
export SHELL='/bin/zsh'
export GPG_TTY=$(tty)
export EDITOR=vim
export PAGER=less
export PDFVIEWER=zathura
export LESSHISTFILE=/dev/null	# don't use the history of less
export PATH=/usr/lib/ccache/bin/:$PATH:$HOME/bin:/usr/bin/vendor_perl/	# use of ccache for compiling and put home/bin in path
export BROWSER="chromium"
export DOWNLOAD=$HOME/down
export TODOTXT_DEFAULT_ACTION="ls" # show todo list with "t"
export MOZ_DISABLE_PANGO=1 # disable pango for mozilla
#}}}2

# files and folders {{{2
AURDIR=/home/build/AUR
BUILDDIR=/home/build
HOMETMP=$HOME/tmp
DATADIR=$HOME/data
WIKIDIR=$DATADIR/Wiki
DROPBOXDIR=$DATADIR/Dropbox
CONTACTFILE=$HOME/.contacts
#}}}2 
# }}}1

# configuration {{{1
setopt autocd		# change directories easily
setopt no_beep		# disable annoying beeps
setopt complete_in_word # also do complete in words
setopt correct		# try to find misspellings
setopt auto_pushd	# always use the directory stack
setopt pushd_ignore_dups # never duplicate entries
setopt extended_glob	# use # ~ and ^ for filename generation
setopt longlistjobs	# display PID when suspending processes as well
setopt braceccl		# use advanced brace expasion like {a-b}
setopt nohup		# don't send hup when shell terminates
setopt transient_rprompt # remove rprompt when command is issued
setopt functionargzero	# set $0 to the function call
setopt local_options	# allow functions to have local options

unsetopt flowcontrol	# deactivate "freezing"

autoload -U colors && colors	# use colours
autoload -U zmv			# great batch-renaming tool
autoload -U url-quote-magic	# smart urls
zle -N self-insert url-quote-magic

eval $(dircolors -b)		# colours for ls

umask 066	# initialize new files with -rw-------

# history {{{2
HISTFILE="$HOME/.histfile" # where to put the history
HISTSIZE=10000
SAVEHIST=12000
HISTIGNORE="exit"

setopt share_history 		# share the history over multiple instances
setopt extended_history 	# put the time into history
setopt hist_no_store 		# don't save history commands
setopt hist_reduce_blanks 	# delete unneeded blanks
setopt hist_ignore_all_dups 	# never duplicate entries
setopt hist_ignore_space 	# don't put commands starting with a blank into history
setopt hist_verify 		# show history-completed commands before execution
#}}}2

# completion {{{2
zstyle :compinstall filename "$HOME/.zshrc"
autoload -Uz compinit && compinit
zmodload -i zsh/complist

zstyle ':completion::complete:*' rehash true
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' verbose yes
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format $'%{[0;31m%}%d%{[0m%}'
zstyle ':completion:*:corrections' format $'%{[0;31m%}%d%{[0m%}'
zstyle ':completion:*:messages' format $'%{[0;31m%}%d%{[0m%}'
zstyle ':completion:*:warnings' format $'%{[0;31m%}%d%{[0m%}'
zstyle ':completion:*:(all-|)files' ignored patterns "(*.BAK|*.bak|*.o|*.aux|*.toc|*.swp|*~)"
zstyle ':completion:*:rm:*:(all-|)files' ignored patterns
zstyle ':completion:*' menu select=2
zstyle ':completion:*:default' select-prompt '%SMatch %M    %P%s'
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
# expand global aliases
zstyle ':completion:*:expand-alias:*' global true
# insert/complete sections for man pages
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.*' insert-sections true
zstyle ':completion:*:man:*' menu yes select
# list processes when completing "kill"
zstyle ':completion:*:kill:*' command 'ps xf -u $USER -o pid,%cpu,cmd'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;32'
#}}}2

# keys {{{2
bindkey -e	# i don't like zsh's vi-mode

# vim-like history "completion" with arrow keys
# using C-r for searching works better
#bindkey "^[[A" up-line-or-search
#bindkey "^[[B" down-line-or-search

# jump behind the first word on the cmdline.
function jump_after_first_word() {
    local words
    words=(${(z)BUFFER})

    if (( ${#words} <= 1 )) ; then
        CURSOR=${#BUFFER}
    else
        CURSOR=${#${words[1]}}
    fi
}
zle -N jump_after_first_word
bindkey '^xa' jump_after_first_word

# prepend sudo
run-with-sudo () { LBUFFER="sudo $LBUFFER" }
zle -N run-with-sudo
bindkey '^Xs' run-with-sudo

# insert last word
bindkey 'm' copy-prev-shell-word

# special keys
bindkey '\e[2~' yank 		# Ins
bindkey '\e[3~' delete-char	# Del
bindkey '\e[5~' up-line-or-history	# PgDown
bindkey '\e[6~' down-line-or-history	# PgUp
bindkey '\e[7~' beginning-of-line # Home
bindkey '\e[8~' end-of-line	  # End

# key bindings for completion
# navigation
bindkey -M menuselect 'h' backward-char
bindkey -M menuselect 'j' down-line-or-history
bindkey -M menuselect 'k' up-line-or-history
bindkey -M menuselect 'l' forward-char
# insert, but accept further completions
bindkey -M menuselect 'i' accept-and-menu-complete
# insert, and show menu with further possible completions
bindkey -M menuselect 'o' accept-and-next-history
# undo
bindkey -M menuselect 'u' undo
#}}}2

# prompt {{{2
PROMPT="%m %B%0(#.%{$fg[red]%}#.%{$fg[white]%}>) %b"
# current directory, jobcount and return value
RPROMPT="%0(5c,%c,%~) %1(j.(%j%).) %(?..%B%{$fg[red]%}%?%{$fg[white]%}%b)"
# Set urgent on completed jobs
precmd() (
    echo -ne '\a'
)
#}}}2

# startup {{{2
# the first terminal spawned after startx shows a calendar and todo list
# TODO: better solution?
if [[ -e /dev/shm/firstrun && $TTY != /dev/tty1
                           && $TTY != /dev/tty2
			   && $TTY != /dev/tty3 ]]; then
   rem -c+2 -w160 -m -b1 && echo "\\n--" && 
    $HOME/bin/todo.sh -d $HOME/.todo/config ls && echo ""
   rm -f /dev/shm/firstrun
fi
#}}}2
#}}}1

# aliases {{{1
# root {{{2
if [[ $EUID = 0 ]]; then
   	# ArchLinux - packages
	alias update="pacman -Syu"
	alias install="pacman -S"
	alias remove="pacman -Rsun"
	# show open connections
	alias hullbreak="netstat --all --numeric --programs --inet"
	# VPN university
	alias UniVPN="openvpn --config /etc/openvpn/openvpn-2.1.client.conf"
fi
# }}}2

# sudo {{{2
if [[ $EUID != 0 ]];then
	# better prompt
	alias sudo="sudo -p '%u -> %U, enter password: ' "

	# ArchLinux - packages
	alias update="sudo pacman -Syu && cower -c -v -u"
	alias install="sudo pacman -S"
	alias remove="sudo pacman -Rsun"
	# System
	alias poweroff="sudo poweroff"
	alias reboot="sudo reboot"
	# show open connections
	alias hullbreak="sudo netstat --all --numeric --programs --inet"
	# VPN university
	alias UniVPN="sudo openvpn --config /etc/openvpn/openvpn-2.1.client.conf"
fi
#}}}2

# normal aliases {{{2
# ls
alias ls="ls --color=auto"
alias l="ls -lhFB"
alias la="ls -lAhB"
# diff
alias diff="colordiff"
# grep
alias grep="grep -i --color=auto"
alias -g G="| grep"
# less
alias more="less"
alias -g L="| less"
# df/du
alias df="df -hT --total"
alias du="du -ch"
# chown
alias c6="chmod 600"
alias c7="chmod 700"
# mkdir
alias md="mkdir -p"
# xargs
alias -g X="| xargs"
# directory stack
alias d="dirs -v"
#jobs
alias j="jobs -l"

# no errors
alias -g NE="2>|/dev/null"
# no output
alias -g NO="&>|/dev/null"
# null
alias -g DN="/dev/null"

# packages & aur
alias savepkglist="comm -23 <(pacman -Qeq) <(pacman -Qmq) > pkglist"
alias mpkg="makepkg -cis"
alias cower="cower -cvt ~aur"

# fetch mail
alias f="fdm f"
# vim
alias v="vim -p"
# screen
alias sr="screen -r"
alias sls="screen -ls"
# irssi
alias irssi="screen -S irssi irssi"
# start bc without startup-message
alias bc="bc -q"

# cclive - Youtube download
alias cclive="cclive --output-dir $HOME/down"
# find out own ip
alias myip="lynx -dump tnx.nl/ip"
# lookup network traffic
alias traffic="vnstat -tr"
# well...
alias totalbullshit="cmatrix -u 2 -a -x"

# suffix-aliases
alias -s txt="vim"
alias -s de=$BROWSER com=$BROWSER org=$BROWSER net=$BROWSER
alias -s pdf=$PDFVIEWER PDF=$PDFVIEWER

# PIM {{{3
# university-stuff
alias stundenplan="cat $HOME/.stundenplan"

# show calendar and todo list
alias pim="clear && rem -c+2 -w160 -m -b1 && echo '\n--' && $HOME/bin/todo.sh -d $HOME/.todo/config ls && echo"

# calendar
alias cal="cal -3"
alias kalender="rem -c+2 -w160 -m -b1"
alias monat="rem -c+4 -w160 -m -b1"
alias dmonat="rem -c+8 -w160 -m -b1"

REMINDERFILE=$HOME/.reminders
alias ttermin="echo 'REM <+Datum+> AT <+Uhrzeit+> DURATION <+Dauer+> MSG %\"<+Terminbeschreibung+> %b %\"' >> $REMINDERFILE && vim +$ $REMINDERFILE"
alias utermin="echo 'REM <+Datum+> MSG %\"<+Terminbeschreibung+>%\"' >> $REMINDERFILE && vim +$ $REMINDERFILE"
alias termin="vim +$ $REMINDERFILE"

alias geburtstag="echo 'rem <+Datum+> msg %\"Geburtstag <+Name+>%\"' >> $HOME/.geburtstage && vim +$ $HOME/.geburtstage"

# todo.sh
alias t="todo.sh -d $HOME/.todo/config"
# quicknote
alias note="cd $WIKIDIR && vim ScratchPad.wiki && cd -"
#}}}3

# git {{{3
alias g="git"

alias ga="git add"
alias gp="git push"

alias gc="git commit"
alias gca="git commit -a"

alias gco="git checkout"
alias gcl="git clone"

alias gl="git log"
alias gs="git status"
alias gd="git diff"
# }}}3
#}}}2

# just on spitfire {{{3
if [[ $HOST = spitfire ]]; then
   # unison synchronization
   alias usync="unison default"
   alias usyncbatch="unison -batch default"
   alias msync="unison -batch musik"
fi #  }}}3

# named directories {{{2
hash -d doc=/usr/share/doc
hash -d howto=/usr/share/linux-howtos
hash -d log=/var/log

hash -d build=$BUILDDIR
hash -d aur=$AURDIR
hash -d abs=$BUILDDIR/ABS

hash -d uni=$DATADIR/Dokumente/Uni/4.\ Semester/
hash -d dropbox=$DROPBOXDIR
hash -d data=$DATADIR
# }}}2
#}}}1

# functions {{{1
# witty one-liners {{{2
# cd to directory and list files
cdl() { cd $1 && l }
# create dir and cd to it
mcd() { mkdir -p $1 && cd $1 }
# colorful ls in less
ll() { ls -lAhB --color=always "$@" | less -r }
# count the files/folders in a directory
lc() { ls -A "$@" | wc -l }
# open readme-file
readme() { less (#ia3)readme*(-.NOL[1,3]) }
# grep the history
hist() { fc -fl -m "*(#i)$1*" 1 | grep -i --color $1 }
#}}}2

# create a dir in tmp and cd to it {{{2
cdtmp() {
    local t
    t=$(mktemp -d)
    echo $t
    builtin cd $t
}
# }}}2

# download aur-packages {{{2
aur() {
        cd $AURDIR
	rm -rf $1 # delete old data
	cower -c -v -t ~aur -d -d $1
	cd $1
	vim PKGBUILD # user-check
} #}}}2

# a simple calculator {{{2
# http://www.zsh.org/mla/users/2003/msg00163.html
zcalc ()  { print $(( ans = ${1:-ans} )) }
zcalch () { print $(( [#16] ans = ${1:-ans} )) }
zcalcd () { print $(( [#10] ans = ${1:-ans} )) }
zcalco () { print $(( [#8] ans = ${1:-ans} )) }
zcalcb () { print $(( [#2] ans = ${1:-ans} )) }
# calculate ascii value
zcalcasc () { print $(( [#16] ans = ##${1:-ans} )) }
# quick access
bindkey -s '\C-xd' "zcalc \'"
# }}}2

# contact manager {{{2
# searches the contacts
c() { 
    awk "BEGIN { RS = \"###\" } /$*/" $CONTACTFILE
}
# Returns the entries which have $2 in field $1
cf() { 
    awk "BEGIN { RS = \"###\"; FS = \"$1: \" } (\$2 ~ \"$2\") { print \$0 }" $CONTACTFILE
}
# adds a new entry
ca() {
    cat>>$CONTACTFILE
    echo "\n###\n">>$CONTACTFILE
}
# edit the contacts
ce() {
    $EDITOR $CONTACTFILE
}
# }}}2

# decides for me {{{2
yn(){
    echo -ne "thinking"
    for i in {1..4}; do
	echo -ne "."
	sleep 0.5
    done
    if [ $RANDOM -gt $RANDOM ]; then
	    print "Yes\!"
    else
	    print "No\!"
    fi
}
# }}}2
# }}}1

# vim:set sw=4 foldmethod=marker:
