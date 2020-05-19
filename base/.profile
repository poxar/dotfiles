# ~/.profile
# generic entrypoint for all login shells

# xdg directories
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-"$HOME/.cache"}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-"$HOME/.config"}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-"$HOME/.local/share"}"

# user supplied exectuables go here
export XDG_BIN_HOME="${XDG_BIN_HOME:-"$HOME/.local/bin"}"
case ":$PATH:" in
  *:"$XDG_BIN_HOME":*) ;;
  *) PATH="$XDG_BIN_HOME:$PATH" ;;
esac

# this will be sourced by all interactive shells
export ENV="${XDG_CONFIG_HOME}/sh/rc"

# set the appropriate editor
if test -x "$(command -v "nvim")"; then
  EDITOR="nvim"
elif test -x "$(command -v "vim")"; then
  EDITOR="vim"
elif test -x "$(command -v "nvi")"; then
  EDITOR="nvi"
else
  EDITOR="vi"
fi
export EDITOR

# load further profiles
PDIR="${PDIR:-"$XDG_CONFIG_HOME/sh/profile.d"}"
if test -d "$PDIR"; then
  for file in "$PDIR"/*.sh; do . "$file"; done
fi
unset PDIR
