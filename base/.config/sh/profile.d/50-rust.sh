export CARGO_HOME="${XDG_CACHE_HOME:-"$HOME/.cache"}/cargo"

CARGO_INSTALL_ROOT="$(dirname "${XDG_BIN_HOME:-"$HOME/.local/bin"}")"
export CARGO_INSTALL_ROOT
