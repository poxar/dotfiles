#!/bin/sh

#
# .xinitrc
#

# load settings for X
xset +fp /usr/share/fonts/local
xset fp rehash
test -f ~/.Xresources && xrdb -merge ~/.Xresources
xsetroot -cursor_name left_ptr

# xinitrc.d global settings
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# disable screensaver
xset s off
xset -dpms
# disable bell
xset -b

# load screen setup
autorandr -c

# start the gnome keyring
eval "$(gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)"
export SSH_AUTH_SOCK

xbindkeys
xinput set-prop 11 "Device Enabled" 0

# start the session
exec openbox-session
