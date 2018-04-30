
#
# ~/.bashrc
# bash entrypoint for the shell configuration framework
#

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-"$HOME/.config"}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-"$HOME/.local/share"}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-"$HOME/.cache"}"

# only process bashrc when interactive
if [[ $- != *i* ]] ; then return; fi

# load configuration files
RCDIR="${RCDIR:-"$XDG_CONFIG_HOME/sh/rc.d"}"
shopt -s extglob
if test -d "$RCDIR"; then
  for file in "$RCDIR"/@(*.bash|*.sh); do source "$file"; done
fi
unset RCDIR
