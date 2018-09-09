
#
# ~/.profile
# Generic entrypoint for the shell configuration framework
#

export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-"$HOME/.config"}
export XDG_DATA_HOME="${XDG_DATA_HOME:-"$HOME/.local/share"}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-"$HOME/.cache"}"

RCDIR="${RCDIR:-"$XDG_CONFIG_HOME/sh/rc.d"}"

if test -d "$RCDIR"; then
  for file in "$RCDIR"/*.sh; do . "$file"; done
fi

unset RCDIR
