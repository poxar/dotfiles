
#
# .zsh/plugin/archlinux.zsh
# stuff for archlinux boxes
#

if [[ -r $(which pacman) ]]; then

    # update mirrorlist using reflector
    alias reflector="$SUDO reflector -c Germany -l 10 --sort score --save \
        /etc/pacman.d/mirrorlist && cat /etc/pacman.d/mirrorlist"

    # build, install and clean a PKGBUILD
    alias mpkg="makepkg -cis"

fi
