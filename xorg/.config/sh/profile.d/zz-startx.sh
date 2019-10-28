export XAUTHORITY="${XDG_DATA_HOME:-"$HOME/.local/share"}/Xauthority"
export XINITRC="${XDG_CONFIG_HOME:-"$HOME/.config"}/X11/xinitrc"
export XSERVERRC="${XDG_CONFIG_HOME:-"$HOME/.config"}/X11/xserverrc"

if test -x "$(command -v xinit)" \
&& test -z "$DISPLAY" \
&& test "$XDG_VTNR" -eq 1
then
  exec xinit
fi
