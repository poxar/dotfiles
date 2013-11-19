
#
# .zlogin
#

# load configuration
if [[ -d $ZLOGIND ]]
then
  for zfile in $ZLOGIND/*.zsh; do; source $zfile; done
  unset zfile
fi
