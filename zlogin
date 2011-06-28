
#
# zlogin
# Maintainer:	Philipp Millar <philipp.millar@gmx.de>
#

clear

# load ssh-agent, store runtime variables in /tmp/ssh-agent.info
if [[ ! -e /tmp/ssh-agent.info ]]; then
    ssh-agent | sed -e 3d > /tmp/ssh-agent.info
fi

# start x-server
if [[ ! -e /tmp/.X0-lock && $TTY == /dev/tty1 ]]; then
    exec startx
fi
