# config.fish
# main user configuration for the fish shell

function cdtmp
  cd (mktemp -d /tmp/tmp.XXXXXX); or return 1
  pwd
end

alias less='less -FqX'
set -xg PAGER 'less -FqX'
set -xg LESSHISTFILE /dev/null
set -xg LESSOPEN ""

# colorful man with limited width
function man
  set -q MANWIDTH; or set -l MANWIDTH 80
  set -l width (tput cols)

  test "$width" -gt "$MANWIDTH"; and set width $MANWIDTH
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

# list open ports
command -sq fstat; and alias ports="fstat | egrep 'internet6? stream'"
command -sq lsof; and alias ports="lsof -iTCP -sTCP:LISTEN -P"
