
#
# zlogin
# Maintainer:	Philipp Millar <philipp.millar@gmx.de>
#

function say() {
    print "[34;1m::[0;37m $*"
}

clear

print "\n[37;1mArch[34mLinux[0;37m $(uname -r) $(basename $TTY)\n"

# start ssh-agent and gpg-agent
eval `keychain -q --eval`

# start MPD only if its not running
pidof mpd &>/dev/null || mpd &>/dev/null

# start x-server
if [[ ! -e /tmp/.X0-lock && $TTY == /dev/tty1 ]]; then
    say "X running"
    exec startx &>/dev/null
fi
