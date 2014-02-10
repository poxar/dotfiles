emulate zsh

TARGET="${TARGET:-$HOME}"
REPOSITORY="${REPOSITORY:-$HOME/.dotfiles}"
CONFFILE=${CONFFILE:-$HOME/.dotrc.zsh}
DEFINITIONS=${DEFINITIONS:-plugins.zsh}

stow_options=(--target="$TARGET")

# issue a message and die
die() {
  echo $1
  exit 1
}

# check if a program can be found
check_env() {
  while [[ -n ${1} ]]; do
    if ! which $1 &>/dev/null; then
      ${finish:-echo} "[!] $1 not found"
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
    die "[!] Neither $PWD/$DEFINITIONS nor $CONFFILE exist. Stop."
  fi
}

# make sure the make environment is sane
finish=die check_env stow zsh git
