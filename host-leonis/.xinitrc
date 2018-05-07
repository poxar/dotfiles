#!/bin/sh

#
# .xinitrc
#

xrandr --dpi 144

# load settings for X
xset +fp /usr/share/fonts/local
xset fp rehash
xsetroot -cursor_name left_ptr

xrfile="${XDG_CONFIG_HOME:-"$HOME/.config"}/Xresources"
test -f "$xrfile" && xrdb -merge "$xrfile"
unset xrfile

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

export GDK_SCALE=1.4
export QT_DEVICE_PIXEL_RATIO=1.4

# setup keyboard
setxkbmap \
  -model thinkpad \
  -layout us \
  -variant altgr-intl \
  -option ctrl:nocaps \
  -option compose:menu-altgr
xbindkeys -f "${XDG_CONFIG_HOME:-"$HOME/.config"}/xbindkeysrc"
# setup trackpoint
xinput set-prop 12 276 0.8

# start the session
dropbox &
wmname LG3D
firefox &
zeal &
st &
dwmstatus &
exec dwm
