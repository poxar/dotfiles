
#
# zshrc
# Maintainer:	Philipp Millar <philipp.millar@gmx.de>
#

# Optionen {{{1
# Konfigurationsvariablen {{{2
# Wichtige Verzeichnisse 
AURDIR=/home/build/AUR
BUILDDIR=/home/build
HOMETMP=$HOME/tmp
DATADIR=$HOME/data
WIKIDIR=$DATADIR/Wiki
DROPBOXDIR=$DATADIR/Dropbox
CONTACTFILE=$HOME/.contacts
#}}}2 

#Umgebungsvariablen {{{2
export GPG_TTY=$(tty)
export EDITOR=vim
export PAGER=less
export PDFVIEWER=zathura
export LESSHISTFILE=/dev/null	# don't use the history of less
export PATH=/usr/lib/ccache/bin/:$PATH:$HOME/bin:/usr/bin/vendor_perl/	# use of ccache for compiling and homebin
export BROWSER="chromium"
export DOWNLOAD=$HOME/down
export TODOTXT_DEFAULT_ACTION="ls" # show todo list with "t"
export MOZ_DISABLE_PANGO=1 # disable pango for mozilla
#}}}2

#Grundsettings {{{2
HISTFILE="$HOME/.histfile" # where to put the history
HISTSIZE=10000
SAVEHIST=12000
bindkey -v	# Vi-Keybindings
umask 066	# init new files with -rw-------
#}}}2

# Shell-Optionen {{{2
setopt autocd		# einfaches wechseln des Verzeichnises
setopt no_beep		# kein piependes nerven
setopt complete_in_word	# auch im wort vervollständigen
setopt correct		# rechtschreibfehler erkennen
setopt auto_pushd	# automatisch den directory-heap erstellen

#History
setopt share_history 		# Geteilte History für alle Instanzen von zsh
setopt extended_history 	# Zeitangaben in der history
setopt hist_no_store 		# history kommandos nicht speichern
setopt hist_reduce_blanks 	# unnötige leerzeichen entfernen
setopt hist_ignore_all_dups 	# keine Duplikate
setopt hist_ignore_space 	# befehle mit einem leerzeichen am anfang nicht speichern
setopt hist_verify 		# mit !-kommandos hervorgeholte einträge erst bestätigen


autoload -U colors && colors	# Farben verwenden
autoload -U zmv			# einfach nur noch ein tolles tool für batch-rename
eval `dircolors`
#}}}2

# Completion {{{2
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
# keybindings for completion
bindkey -M menuselect 'h' backward-char
bindkey -M menuselect 'j' down-line-or-history
bindkey -M menuselect 'k' up-line-or-history
bindkey -M menuselect 'l' forward-char
# history-completion with ^x^x
zle -C hist-complete complete-word _generic
zstyle ':completion:hist-complete:*' completer _history
bindkey '^X^X' hist-complete
# processlist for "kill"
zstyle ':completion:*:kill:*' command 'ps xf -u $USER -o pid,%cpu,cmd'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;32'
#}}}2

# Prompt {{{2
PROMPT="%m %B%0(#.%{$fg[red]%}#.%{$fg[white]%}>) %b"
# aktuelles Verzeichnis, jobzahl und :( bei misserfolg
RPROMPT="%0(5c,%c,%~) %1(j.(%j%).) %(?..%B%{$fg[red]%}:(%{$fg[white]%}%b)"
# Set urgent on completed jobs
precmd() (
  echo -ne '\a'
)
#}}}3
#}}}2

#}}}1

# Aliase {{{1
# Rootaliase {{{2
if [[ $UID = 0 ]]; then

	# nur helo {{{3
	if [[ $HOST = helo ]]; then
	   #MyBook abgleichen
	   alias syncMyBook="mount /media/MyBook/ && rsync -rhu --ignore-existing --progress --delete /media/storage/Filme/ /media/MyBook/Filme/ && rsync -rhu --ignore-existing --progress --delete /media/storage/iso/ /media/MyBook/iso/"
	fi # }}}3

   	# ArchLinux - Packetverwaltung
	alias update="pacman -Syu"
	alias install="pacman -S"
	alias remove="pacman -Rsun"
	# Intrusion Detection / Sicherheitsüberwachung
	alias hullbreak="netstat --all --numeric --programs --inet"
	# OpenVPN der Uni
	alias UniVPN="openvpn --config /etc/openvpn/openvpn-2.1.client.conf"
fi
# }}}2

# sudo Aliase {{{2
if [[ $UID != 0 ]];then
   	# ArchLinux - Packetverwaltung
	alias update="sudo pacman -Syu && cower -c -v -u"
	alias install="sudo pacman -S"
	alias remove="sudo pacman -Rsun"
	# Rechner abschalten/neu starten
	alias poweroff="sudo poweroff"
	alias reboot="sudo reboot"
	# Intrusion Detection / Sicherheitsüberwachung
	alias hullbreak="sudo netstat --all --numeric --programs --inet"
	# OpenVPN der Uni
	alias UniVPN="sudo openvpn --config /etc/openvpn/openvpn-2.1.client.conf"
fi
#}}}2

# Aliase {{{2
# nur helo {{{3
if [[ $HOST = helo ]]; then
   # Spiele
   alias nwn="cd /home/philipp/.spiele/nwn/ && ./nwn && cd -"
   alias nwn2="cd /home/philipp/.spiele/nwn2/drive_c/Programme/Atari/Neverwinter\ Nights\ 2/ && WINEPREFIX='/home/philipp/.spiele/nwn2/' wine nwn2.exe && cd -"
   alias BaldursGate='WINEPREFIX="/home/philipp/.spiele/BaldursGate/" wine E:\Autorun.exe'
   alias BaldursGate2='WINEPREFIX="/home/philipp/.spiele/BaldursGate2/" wine E:\baldur.exe'
   alias DragonAge='WINEPREFIX="/home/philipp/.spiele/DragonAgeOrigins/" wine "C:\Programme\Dragon Age\bin_ship\daorigins.exe"'
   alias AssassinsCreed="cd /home/philipp/.spiele/AssassinsCreed/drive_c/Programme/Ubisoft/Assassins\ Creed/ && WINEPREFIX='/home/philipp/.spiele/AssassinsCreed/' wine AssassinsCreed_Dx9.exe && cd -"
fi #  }}}3
# nur spitfire {{{3
if [[ $HOST = spitfire ]]; then
   # unison synx
   alias usync="unison default"
   alias usyncbatch="unison -batch default"
   alias msync="unison -batch musik"
fi #  }}}3

# Startup {{{3
# Startskript
# Falls nach startx noch keine zshell geöffnet wurde werden interresante
# Informationen angezeigt. TODO: schönere Lösung?!
if [[ -e /dev/shm/firstrun && $TTY != /dev/tty1
                           && $TTY != /dev/tty2
			   && $TTY != /dev/tty3 ]]; then
   rem -cl+2 -w160 -m -b1 && echo "\\n--" && 
    $HOME/bin/todo.sh -d $HOME/.todo/config ls && echo ""
   rm -f /dev/shm/firstrun
fi
#}}}3

# Zsh {{{3
# Directory Stack
alias d="dirs -v" # list dir-stack
#jobs
alias j="jobs -l" # list active jobs
# History
alias hist="history | grep" # find history-command (delete?)
# schnelles cd
alias -g ...="../.."
alias -g ....="../../.."
alias -g .....="../../../.."
# Autoextrahieren
alias -s 7z="7z x"
alias -s bz2="pbzip2 -d"
alias -s gz="gzip -d"
alias -s tar="tar xvf"
alias -s rar="unrar"
alias -s zip="unzip"
# Suffix-Aliase
alias -s txt="vim"
alias -s de=$BROWSER com=$BROWSER org=$BROWSER net=$BROWSER
alias -s pdf=$PDFVIEWER PDF=$PDFVIEWER
# keine history anlegen
alias inkognito="fc -p"
#}}}3

# Coreutils & Erweiterungen {{{3
# ls
alias ls="ls --color=auto"
alias l="ls -lhFB"
alias la="ls -lAhB"
alias ll="ls -lAhB | less -F"
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
# screen
alias sr="screen -r"
alias sls="screen -ls"
# paketverwaltung
alias savepkglist="comm -23 <(pacman -Qeq) <(pacman -Qmq) > pkglist"
alias mpkg="makepkg -cis"
alias cower="cower -c -v -t ~aur"
#}}}3

# PIM {{{3
# Uni-Stundenplan
alias stundenplan="cat $HOME/.stundenplan"
# Kalender
alias pim="clear && rem -c+2 -w160 -m -b1 && echo '\n--' && $HOME/bin/todo.sh -d $HOME/.todo/config ls && echo"

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

# Unsortiert {{{3
# Pastebin
alias pastebin="curl -F 'sprunge=<-' http://sprunge.us"
# cclive - Youtube download
alias cclive="cclive --output-dir $HOME/down"
# hust
alias totalbullshit="cmatrix -u 2 -a -x"
# irssi
alias irssi="screen -S irssi irssi"
# bit.ly
#alias surl="surl -s bit.ly -c"
#}}}3
#}}}2

# benannte Verzeichnise {{{2
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

# Funktionen {{{1
# AUR-Pakete downloaden {{{2
aur() {
        cd $AURDIR && # Verzeichnis
	rm -rf $1 && # alte Daten löschen
	#aria2c -x 2 -d $AURDIR http://aur.archlinux.org/packages/$1/$1.tar.gz && # download
	#tar -xzvf $1.tar.gz && # entpacken
	#rm $1.tar.gz && # verpacktes löschen
	cower -c -v -t ~aur -d -d $1 &&
	cd $1 && # Verzeichnis
	vim PKGBUILD # user-check
} #}}}2

# Die Einträge in einem Ordner zählen {{{2
countentry() {
   count=0
   for i in *; do
      count=$(($count+1))
   done
   print $count
} #}}}2

# Ein Taschenrechner in verschiedenen Zahlensystemen {{{2
zcalc ()  { print $(( ans = ${1:-ans} )) }
zcalch () { print $(( [#16] ans = ${1:-ans} )) }
zcalcd () { print $(( [#10] ans = ${1:-ans} )) }
zcalco () { print $(( [#8] ans = ${1:-ans} )) }
zcalcb () { print $(( [#2] ans = ${1:-ans} )) }
# ascii - Wert eines characters
zcalcasc () { print $(( [#16] ans = ##${1:-ans} )) }
#keybinding
bindkey -s '\C-xd' "zcalc \'"
#http://www.zsh.org/mla/users/2003/msg00163.html }}}2

# Contactmanager {{{2
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
#}}}1

#######################################################################

# TODO {{{1
# - schönere Lösung für das Startupskript
# }}}1

# vim:set foldmethod=marker:
