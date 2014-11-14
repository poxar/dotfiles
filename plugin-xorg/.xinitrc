
#
# .xinitrc
#

# load settings for X
xset +fp /usr/share/fonts/local
xset fp rehash
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
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

# load keybindings
xbindkeys &

# load screen setup
autorandr -c

# disable touchpad
synclient TouchpadOff=1

exec openbox-session
