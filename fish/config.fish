# No need for such formalities
set -g fish_greeting

if command -q nvim
  set -xg EDITOR nvim
  alias vim nvim
else if command -q vim
  set -xg EDITOR vim
else
  set -xg EDITOR vi
  alias vim vi
end

# Use a sane browser
set -xg BROWSER firefox

# Make chmod u=rwX,g=rX,o= the default
umask 0027

abbr -ag less less -FqX
set -xg PAGER 'less -FqX'
set -xg LESSHISTFILE -
set -xg LESSOPEN ""

# Local scripts and tools
contains $HOME/.local/bin $PATH
or set -xgp PATH $HOME/.local/bin

# Automatically fix typos
abbr -ag sl ls

# Setup some tools
command -q lsof; and abbr -ag ports "lsof -iTCP -sTCP:LISTEN -P"
command -q direnv; and direnv hook fish | source

# Some tweaks to the default colors
set fish_color_valid_path
set fish_pager_color_prefix white\x1e\x2d\x2dbold\x1e\x2d\x2d
set fish_color_comment 585858
set fish_color_option 005fd7
