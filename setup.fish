#!/usr/bin/env fish
# Sets some universal variables and similar one-off tasks
# Should be kept minimal, since this needs to be run on all machines after it
# has been changed. Sadly some settings are not easily configured otherwise in
# fish.

# Setup XDG base directory variables
# This way we can be sure they are set in the rest of the configuration
set -Ux XDG_CONFIG_HOME $HOME/.config
set -Ux XDG_CACHE_HOME  $HOME/.cache
set -Ux XDG_PREFIX_HOME $HOME/.local
set -Ux XDG_BIN_HOME    $HOME/.local/bin
set -Ux XDG_DATA_HOME   $HOME/.local/share

fish_add_path $XDG_BIN_HOME

# Don't underline anything
set -U fish_color_valid_path \x2d\x2d
set -U fish_pager_color_prefix white\x1e\x2d\x2dbold\x1e\x2d\x2d

# Sane comment color
set -U fish_color_comment 585858
