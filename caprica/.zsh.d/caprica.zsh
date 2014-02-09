
#
# .zsh.d/caprica.zsh
#

hash -d data=$HOME/data
hash -d dokumente=~data/Dokumente
hash -d dropbox=~data/Dropbox
hash -d bib=~data/Bibliothek
hash -d uni=~dropbox/Uni
hash -d shares=/run/user/1000/gvfs

alias dup="sudo duply mybook"

function mount-tauron() {
  udevil mount -o credentials=/home/philipp/.smbcred-tauron smb://pmi@tauron/$1
}
compctl -k "(pmi public backup download configuration)" mount-tauron
