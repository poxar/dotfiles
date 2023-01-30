set -xg XDG_CACHE_HOME  $HOME/.cache
set -xg XDG_CONFIG_HOME $HOME/.config
set -xg XDG_DATA_HOME   $HOME/.local/share
set -xg XDG_STATE_HOME  $HOME/.local/state

# Local scripts and tools
contains $HOME/.local/bin $PATH
or set -xgp PATH $HOME/.local/bin

# rust
set -xg CARGO_HOME $XDG_STATE_HOME/cargo
set -xg RUSTUP_HOME $XDG_STATE_HOME/rustup
contains $CARGO_HOME/bin $PATH
or set -xgp PATH $CARGO_HOME/bin

# python
set -xg PYTHON_EGG_CACHE $XDG_CACHE_HOME/python-eggs

# elm
set -xg ELM_HOME $XDG_STATE_HOME/elm

# go
set -xg GOPATH $XDG_STATE_HOME/go

# nodejs
set -xg NPM_CONFIG_USERCONFIG $XDG_CONFIG_HOME/npm/npmrc
contains $XDG_STATE_HOME/npm/bin $PATH
or set -xgp PATH $XDG_STATE_HOME/npm/bin

# haskell
set -xg STACK_ROOT $XDG_DATA_HOME/stack

# IDF
set -gx IDF_TOOLS_PATH $XDG_STATE_HOME/espressif

# openssl
set -xg RANDFILE $XDG_STATE_HOME/openssl/rnd

# databases
set -xg SQLITE_HISTORY $XDG_STATE_HOME/sqlite/history
set -xg PSQL_HISTORY $XDG_STATE_HOME/psql/history
set -xg MYSQL_HISTFILE $XDG_STATE_HOME/mysql/history
set -xg REDISCLI_HISTFILE $XDG_STATE_HOME/redis/history

# docker
set -xg DOCKER_CONFIG $XDG_CONFIG_HOME/docker

# wget
set -xg WGETRC $XDG_CONFIG_HOME/wgetrc
