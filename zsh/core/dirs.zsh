
#
# .zsh/dirs.zsh
# named directories
#

hash -d doc=/usr/share/doc
hash -d log=/var/log
hash -d bin=$HOME/bin
hash -d tmp=$HOME/tmp

if [[ $(uname -n) == "littlesmoke" ]]; then

    hash -d code=$HOME/code
    hash -d data=$HOME/data

    hash -d dokumente=~data/Dokumente
    hash -d bib=~data/Bibliothek
    hash -d dropbox=~data/Dropbox

    hash -d uni=~dokumente/Uni

fi
