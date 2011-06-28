
#
# zlogin
# Maintainer:	Philipp Millar <philipp.millar@gmx.de>
#

clear

# start x-server
if [[ ! -e /tmp/.X0-lock && $TTY == /dev/tty1 ]]; then
    exec startx
fi
