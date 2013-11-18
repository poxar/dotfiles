
#
# ~/.zshrc
# initializes some variables and loads configuration files
#

ZDIR=$HOME/.zshrc.d

export PATH="$HOME/bin:$PATH"
export EDITOR=vim
export GPG_TTY=$(tty)
export LESSHISTFILE=/dev/null
export VERSION_CONTROL=numbered

# ls colors
if [ -x `which dircolors` ]; then
  eval `dircolors -b` && \
  export ZLS_COLORS=$LS_COLORS
fi

# sudo mask
(( EUID != 0 )) && SUDO='sudo' || SUDO=''

# (GNU) standard flags
ls_options=( --color=auto )
grep_options=( --color=auto )
mktemp_options=()
# create backup files
cp_options=(-b)
mv_options=(-b)

# completions
fpath=($HOME/.fpath $fpath)

# load configuration files
for zfile in $ZDIR/*.zsh; do; source $zfile; done
unset zfile

# automatically remove duplicates
typeset -U path cdpath fpath manpath

unset SUDO
unset grep_options
unset ls_options
unset mktemp_options
unset cp_options
unset mv_options
