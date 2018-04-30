RCDIR="$XDG_CONFIG_HOME/sh/login.d"
if test -d "$RCDIR"; then
  for file in "$RCDIR"/(*.zsh|*.sh); do source "$file"; done
fi
unset RCDIR
