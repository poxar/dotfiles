
#
# zlogin
# Maintainer:	Philipp Millar <philipp.millar@gmx.de>
#

clear
if [[ ! -e /dev/shm/.transmission-run ]]; then
    # start transmission-daemon
    transmission-daemon
    # make lock-file
    touch /dev/shm/.transmission-run
fi
if [[ ! -e /tmp/.X0-lock && $TTY == /dev/tty1 ]]; then
    # show calendar and todo when first xterminal is spawned
    touch /dev/shm/firstrun
    # start x-server and log-out if it quits
    exec startx
fi
