#!/bin/zsh

# Dead simple dotfile management
# Author: Philipp Millar <philipp.millar@gmx.de>
#
# TODO: link directories recursively (and mkdir)
# TODO: apply machine dependent patches of the form dofile.machine.patch?
#

setopt extendedglob
basename=$(basename $0)
cd ~/.dotfiles

# (#i)   case insensitive
# *      select all files
# ~(...) except these
dotfiles=( (#i)*~(readme|link.sh|*.patch) )

usage() {
    print "$basename -- dead simple dotfile management\n"
    print "$basename link   - symlink dotfiles into $HOME"
    print "$basename remove - remove dotfiles from $HOME"
    print "$basename print  - print the affected files"
}

link() {
    for i in $dotfiles; do
        ln -s ~/.dotfiles/$i ~/.$i
    done
}

remove() {
    for i in $dotfiles; do
        rm -r ~/.$i
    done
}

list() {
    for i in $dotfiles; do
        if [[ -d $i ]]; then; i=$i/; fi
        print "$HOME/.$i -> $HOME/.dotfiles/$i"
    done
}

if   [[ $1 == "l" || $1 == "link"   ]]; then; link
elif [[ $1 == "r" || $1 == "remove" ]]; then; remove
elif [[ $1 == "p" || $1 == "print"  ]]; then; list
else; usage
fi

cd -
