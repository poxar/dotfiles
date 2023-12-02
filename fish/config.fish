# No need for such formalities
set -g fish_greeting

set -xg EDITOR nvim
abbr -ag v nvim
abbr -ag vs nvim -S Session.vim

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
  abbr -a --position anywhere --set-cursor T "% | tail"
  abbr -a --position anywhere --set-cursor F "% | tail -f"

  abbr -a --position anywhere G "| grep"
  abbr -a --position anywhere S "| sort"
  abbr -a --position anywhere U "| uniq"

  if command -q wl-copy
    abbr -a --position anywhere --set-cursor C "% | wl-copy"
  end
end

# Setup some tools
command -q lsof; and abbr -ag ports "lsof -iTCP -sTCP:LISTEN -P"
command -q direnv; and direnv hook fish | source
command -q bsdtar; and abbr -a tar bsdtar

# Some tools rely on dircolors
eval (dircolors -c)

# Some tweaks to the default colors
fish_config theme choose None
set fish_color_comment brblack
set fish_color_error red
set fish_color_quote green
set fish_color_valid_path blue
set fish_pager_color_prefix --bold
