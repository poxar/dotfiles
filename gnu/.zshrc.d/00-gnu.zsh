
#
# .zsh/00-gnu.zsh
# defaults for GNU Coreutils
#

# be colorful
if [ -x `which dircolors` ]; then
  eval `dircolors -b` && \
  export ZLS_COLORS=$LS_COLORS
fi

ls_options+=(--color=auto)
grep_options+=(--color=auto)

# colorful ls in less
ll() { ls -lAh --color=always "$@" | less -r }

# create backup files
export VERSION_CONTROL=numbered
cp_options+=(-b)
mv_options+=(-b)
