# Force some level of xdg base directory compliance

# libinput
set -gx INPUTRC $XDG_CONFIG_HOME/inputrc

# c
set -gx GCC_COLORS 'error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
set -gx CCACHE_DIR $XDG_CACHE_HOME/ccache

# python
set -gx PYTHON_EGG_CACHE $XDG_CACHE_HOME/python-eggs
set -gx PYLINTHOME $XDG_CACHE_HOME/pylint
set -gx PYTHONSTARTUP $XDG_CONFIG_HOME/python/cli.py

# rust
set -gx CARGO_HOME $XDG_CACHE_HOME/cargo
set -gx CARGO_INSTALL_ROOT $XDG_PREFIX_HOME

# go
set -gx GOPATH $XDG_CACHE_HOME/go
set -gx GOBIN $XDG_BIN_HOME
