# config.fish
# main user configuration for the fish shell

set -g fish_greeting

if test -x (command -v nvim)
  set -xg EDITOR nvim
else
  set -xg EDITOR vim
end

# only group and owner
umask 0027

function cdtmp
  cd (mktemp -d /tmp/tmp.XXXXXX); or return 1
  pwd
end

abbr -ag less less -FqX
set -xg PAGER 'less -FqX'
set -xg LESSHISTFILE /dev/null
set -xg LESSOPEN ""

abbr -ag ll ls -lAh
abbr -ag sl ls

abbr -ag du du -h

# colorful man with limited width
function man
  set -q MANWIDTH; or set -l MANWIDTH 80
  set -l width (tput cols)

  test "$width" -gt "$MANWIDTH"; and set width $MANWIDTH

  if test -x (command -v nvim)
    set -gx MANPAGER nvim +Man!
    command man $argv
  else
    env \
      LESS_TERMCAP_mb=(printf "\\e[1;31m") \
      LESS_TERMCAP_md=(printf "\\e[1;31m") \
      LESS_TERMCAP_me=(printf "\\e[0m") \
      LESS_TERMCAP_se=(printf "\\e[0m") \
      LESS_TERMCAP_so=(printf "\\e[1;44;33m") \
      LESS_TERMCAP_ue=(printf "\\e[0m") \
      LESS_TERMCAP_us=(printf "\\e[1;32m") \
      MANWIDTH="$width" \
      man $argv
  end
end
