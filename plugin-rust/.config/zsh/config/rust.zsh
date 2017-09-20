rust_default_chain="$(rustup toolchain list | grep \(default\) | awk '{ print $1 }')"
export RUST_SRC_PATH="$HOME/.rustup/toolchains/$rust_default_chain/lib/rustlib/src/rust/src/"
unset rust_default_chain
