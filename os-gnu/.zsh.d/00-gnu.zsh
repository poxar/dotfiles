
#
# .zsh/00-gnu.zsh
# defaults for GNU Coreutils
#

# be colorful
eval `dircolors -b` && \
  export ZLS_COLORS=$LS_COLORS

ls_options+=(--color=auto)
export GREP_OPTIONS="--color=auto $GREP_OPTIONS"

# colorful ls in less
ll() { ls -lAh --color=always "$@" | less -r }

# create backup files
export VERSION_CONTROL=numbered
cp_options+=(-b)
mv_options+=(-b)
