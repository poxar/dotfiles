export ASPROOT=~/.cache/asp

# command-not-found hook via pkgfile
source /usr/share/doc/pkgfile/command-not-found.zsh

# list huge packages
alias hugepkg='expac -s -H M "%-30n %m" | sort -rhk 2 | head'
