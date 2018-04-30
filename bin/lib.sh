TARGET="${TARGET:-$HOME}"
REPOSITORY="${REPOSITORY:-"$HOME/.dotfiles"}"
CONFFILE=${CONFFILE:-"$HOME/.dotrc.sh"}
DEFINITIONS=${DEFINITIONS:-"./plugins.sh"}
STOW_OPTIONS=${STOW_OPTIONS:-""}

# check if a command is available
check() {
  test -x "$(command -v "$*")"
}

if check stow; then
  STOW_OPTIONS="--target=$TARGET $STOW_OPTIONS"
  STOW=stow
else
  echo "[!] stow not found!" >&2
  exit 1
fi

# link the plugins with stow
deploy() {
  while test -n "${1:-""}"; do
    echo "linking $1"
    $STOW $STOW_OPTIONS -R "$1"
    shift
  done
}

# clean up
clean() {
  while test -n "$1"; do
    echo "unlinking ${1}"
    $STOW $STOW_OPTIONS -D "$1"
    shift
  done
}

# read in the configuration; guess if no configuration file exists
read_config() {
  if test -f "$CONFFILE"; then
    . "$CONFFILE"
  elif test -f "$DEFINITIONS"; then
    . "$DEFINITIONS"
  else
    echo "[!] Neither $PWD/$DEFINITIONS nor $CONFFILE exist. Stop." >&2
    exit 1
  fi
}
