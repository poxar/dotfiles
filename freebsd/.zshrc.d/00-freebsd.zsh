
#
# ~/.zsh/00-freebsd.zsh
# defaults for FreeBSD
#

# be colorful
export CLICOLOR=1

# colorful ls in less
ll() { CLICOLOR_FORCE=1 ls -lAh "$@" | less -r }

# ask if override is ok
cp_options+=("-i")
mv_options+=("-i")

mktemp_options+=(-t tmp)
