
#
# .zsh/00-gnu.zsh
# defaults for GNU Coreutils
#

export OS='GNU'

# be colorful
eval `dircolors -b` && \
  export ZLS_COLORS=$LS_COLORS

ls_options+=(--color=auto)
export GREP_OPTIONS="--color=auto $GREP_OPTIONS"

# create backup files
export VERSION_CONTROL=numbered
cp_options+=(-b)
mv_options+=(-b)
