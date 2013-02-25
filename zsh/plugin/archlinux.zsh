
#
# .zsh/plugin/archlinux.zsh
# stuff for archlinux boxes
#

if [[ -r $(which pacman) ]]; then

    # update mirrorlist using reflector
    alias reflector="$SUDO reflector -c Germany -l 10 --sort score --save \
        /etc/pacman.d/mirrorlist && cat /etc/pacman.d/mirrorlist"

    # list explicitly installed packages that are not in base or base-devel
    paclist() { pacman -Qei | awk '/^Name/ { name=$3 } /^Groups/
        { if ( $3 != "base" && $3 != "base-devel" ) { print name } }' }

    # build, install and clean a PKGBUILD
    alias mpkg="makepkg -cis"

fi
