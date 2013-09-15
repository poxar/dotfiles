
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

# start gnome keyring
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets)
export GNOME_KEYRING_CONTROL GNOME_KEYRING_PID GPG_AGENT_INFO SSH_AUTH_SOCK

# disable screensaver
xset s off
xset -dpms
# disable bell
xset -b

# load keybindings
xbindkeys &

exec ~/bin/rp-init
