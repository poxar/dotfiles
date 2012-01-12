
#
# zlogin
# Maintainer:	Philipp Millar <philipp.millar@gmx.de>
#

clear

# start ssh-agent and gpg-agent
eval `keychain --eval`

# start MPD only if its not running
pidof mpd >/dev/null || mpd >/dev/null

# start x-server
if [[ ! -e /tmp/.X0-lock && $TTY == /dev/tty1 ]]; then
    exec startx
fi
