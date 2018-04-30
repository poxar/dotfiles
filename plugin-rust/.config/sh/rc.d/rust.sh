RUSTUP_HOME="$HOME/.local/rustup"
export RUSTUP_HOME

CARGO_HOME="${XDG_CACHE_HOME:-"$HOME/.cache"}/cargo"
export CARGO_HOME

CARGO_INSTALL_ROOT="$HOME/.local/cargo"
export CARGO_INSTALL_ROOT
_pd_addpath "$HOME/.local/cargo/bin"

rust_default_chain="$(rustup toolchain list | grep \(default\) | awk '{ print $1 }')"
RUST_SRC_PATH="${RUSTUP_HOME:-"$HOME/.rustup"}/toolchains/$rust_default_chain/lib/rustlib/src/rust/src/"
export RUST_SRC_PATH
unset rust_default_chain
