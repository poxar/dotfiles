
#
# .zlogin.d/caprica.zsh
#

if which startx &>/dev/null && \
  [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]]
then
   exec startx > ~/.xlog
fi
