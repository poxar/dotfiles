
#
# .zsh/topics/archlinux.zsh
# stuff for archlinux boxes
#

if [[ -r $(which pacman) ]]; then

    # update mirrorlist using reflector
    [[ $EUID != 0 ]] && alias reflector="sudo reflector -c Germany -l 10 --sort score --save /etc/pacman.d/mirrorlist && cat /etc/pacman.d/mirrorlist"

    # list explicitly installed packages that are not in base or base-devel
    paclist() { pacman -Qei | awk '/^Name/ { name=$3 } /^Groups/ { if ( $3 != "base" && $3 != "base-devel" ) { print name } }' }
    # list packages explicitly installed
    alias printpkglist="comm -23 <(pacman -Qeq | sort) <(pacman -Qmq | sort)"

    # build and install
    alias mpkg="makepkg -cis"

fi
