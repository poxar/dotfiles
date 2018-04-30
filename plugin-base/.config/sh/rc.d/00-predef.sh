
#
# predef
# standard library for the configuration framework
#

# check if a command is available
_pd_check() {
  test -x "$(command -v "$*")"
}

# check if a shell function or builtin is available
_pd_func() {
  type "$*" >/dev/null
}

# prepend to PATH
_pd_addpath() {
  case ":$PATH:" in
    *:"$1":*) ;;
    *) PATH="$1:$PATH" ;;
  esac
}

_pd_addpath "$HOME/.local/bin"
