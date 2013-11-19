
#
# .zlogout
#

clear

# load configuration
if [[ -d $ZLOGOUTD ]]; then
  for zfile in $ZLOGOUTD/*.zsh; do; source $zfile; done
  unset zfile
fi
