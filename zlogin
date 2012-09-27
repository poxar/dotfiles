
#
# zlogin
# Maintainer:	Philipp Millar <philipp.millar@gmx.de>
#

clear

# print some system info
[[ $(uname -r ) =~ .*-ARCH ]] && print "\n[37;1mArch[34mLinux[0;37m $(uname -r) $(basename $TTY)\n"

# start ssh-agent and gpg-agent
eval `keychain -q --eval`

# initialize tmp directories
[[ -d /tmp/macromedia ]] || mkdir /tmp/macromedia
[[ -d /tmp/adobe ]] || mkdir /tmp/adobe
