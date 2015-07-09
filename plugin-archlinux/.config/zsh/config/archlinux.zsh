# update mirrorlist using reflector
alias reflector="$SUDO reflector -c Germany -l 10 --sort score --save \
  /etc/pacman.d/mirrorlist && cat /etc/pacman.d/mirrorlist"

# build, install and clean a PKGBUILD
alias mpkg="makepkg -rsiL"

# saner abs
export ABSROOT=~/build/abs
export ASPROOT=~/.cache/asp

# command-not-found hook via pkgfile
source /usr/share/doc/pkgfile/command-not-found.zsh

# list huge packages
alias hugepkg='expac -s -H M "%-30n %m" | sort -rhk 2 | head'
