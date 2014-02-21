emulate zsh

TARGET="${TARGET:-$HOME}"
REPOSITORY="${REPOSITORY:-$HOME/.dotfiles}"
CONFFILE=${CONFFILE:-$HOME/.dotrc.zsh}
DEFINITIONS=${DEFINITIONS:-plugins.zsh}

stow_options=(--target="$TARGET")

# check if a program can be found
check_env() {
  while [[ -n ${1} ]]; do
    if ! which $1 &>/dev/null; then
      echo "[!] $1 not found" >&2
      exit 1
    fi
    shift
  done
}

# link the plugins with stow
deploy() {
  while [[ -n ${1} ]]; do
    echo "linking ${1}"
    stow ${stow_options} -R ${1}
    shift
  done
}

# clean up
clean() {
  while [[ -n ${1} ]]; do
    echo "unlinking ${1}"
    stow ${stow_options} -D ${1}
    shift
  done
}

# read in the configuration; guess if no configuration file exists
read_config() {
  if [[ -f "$CONFFILE" ]]; then
    source "$CONFFILE"
  elif [[ -f "$DEFINITIONS" ]]; then
    source "$DEFINITIONS"
  else
    echo "[!] Neither $PWD/$DEFINITIONS nor $CONFFILE exist. Stop." >&2
    exit 1
  fi
}

# make sure the make environment is sane
check_env stow zsh git
