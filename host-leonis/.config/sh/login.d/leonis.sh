if test -x "$(command -v startx)" && test -z "$DISPLAY" && test "$XDG_VTNR" -eq 1
then
   exec startx > ~/.local/share/xorg/Xorg.output.log
fi
