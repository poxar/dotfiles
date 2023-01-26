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

# Automatically fix typos
abbr -ag sl ls

# simple piping
if test (echo $FISH_VERSION | tr -d . | sed 's/-.*//') -ge 360
  abbr -a --position anywhere --set-cursor L "% | less -FqX"
  abbr -a --position anywhere --set-cursor G "% | grep"
  abbr -a --position anywhere --set-cursor S "% | sort"
  abbr -a --position anywhere --set-cursor T "% | tail"
  abbr -a --position anywhere --set-cursor F "% | tail -f"

  if command -q wl-copy
    abbr -a --position anywhere --set-cursor C "% | wl-copy"
  end
end

# Setup some tools
command -q lsof; and abbr -ag ports "lsof -iTCP -sTCP:LISTEN -P"
command -q direnv; and direnv hook fish | source

# Some tweaks to the default colors
set fish_color_valid_path
set fish_pager_color_prefix white\x1e\x2d\x2dbold\x1e\x2d\x2d
set fish_color_comment 585858
set fish_color_option 005fd7
