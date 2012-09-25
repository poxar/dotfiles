#!/bin/zsh

# Dead simple dotfile management
# Author: Philipp Millar <philipp.millar@gmx.de>
#
# TODO: apply machine dependent patches of the form dofile.machine.patch?
# TODO: completely machine dependent files? (dotfile__machine)
#

# enable heavy globbing
setopt extendedglob
# set the basename
basename=$(basename $0)
# where are our dotfiles?
DOTREPO=$HOME/.dotfiles
# cd into the repo, so we don't have to care about paths
cd $DOTREPO
# select the files, that go in ~
# (#i)     case insensitive
# *        select all files
# ~(...)   except these
# config/* oh and take the ones in config too
dotfiles=( (#i)*~(readme|link.sh|config|*.patch) config/* )

usage() {
    print "$basename -- dead simple dotfile management\n"
    print "$basename link   - symlink dotfiles into $HOME"
    print "$basename remove - remove dotfiles from $HOME"
    print "$basename print  - print the affected files"
}

link() {
    # link dotfiles
    for i in $dotfiles; do
        if [[ -e ~/.$i ]]; then
            print "$HOME/.$i exists. I refuse to overwrite it."
        else
            ln -s $DOTREPO/$i ~/.$i
        fi
    done

    # create ~/bin unless it exists
    if [[ ! -e ~/bin ]]; then
        mkdir ~/bin
    elif [[ ! -d ~/bin ]]; then
        print "$HOME/bin exists, but it's not a directory."
        exit 1
    fi

    # link files to ~/bin
    for i in bin/*; do
        if [[ -e ~/$i ]]; then
            print "$HOME/$i exists. I refuse to overwrite it."
        else
            ln -s $DOTREPO/$i ~/$i
        fi
    done
}

remove() {
    # delete files, unless they are no symlinks
    for i in $dotfiles; do
        if [[ -h ~/.$i ]]; then
            rm -rf ~/.$i
        else
            print "$HOME/.$i is no symlink. I refuse to delete it."
        fi
    done
    # do the same for bin
    for i in bin/*; do
        if [[ -h ~/$i ]]; then
            rm -rf ~/$i
        else
            print "$HOME/$i is no symlink. I refuse to delete it."
        fi
    done
}

list() {
    for i in $dotfiles; do
        if [[ -d $i ]]; then; i=$i/; fi
        print "$HOME/.$i -> $DOTREPO/$i"
    done
    for i in bin/*; do
        print "$HOME/$i -> $DOTREPO/$i"
    done
}

if   [[ $1 == "l" || $1 == "link"   ]]; then; link
elif [[ $1 == "r" || $1 == "remove" ]]; then; remove
elif [[ $1 == "p" || $1 == "print"  ]]; then; list
else; usage
fi

# back to original path
cd -
