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

# setup keyboard
setxkbmap \
  -model thinkpad \
  -layout us,de \
  -variant altgr-intl,nodeadkeys \
  -option ctrl:nocaps \
  -option compose:menu-altgr \
  -option grp:shifts_toggle \
  -option grp_led:caps
xbindkeys
toggle-touchpad

# start the session
nm-applet &
firefox &
st &
dwmstatus &
exec dwm
