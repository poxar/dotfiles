
#
# ~/.zshrc
# initializes some variables and loads configuration files
#

ZDIR=$HOME/.zsh

export PATH="$HOME/bin:$PATH"
export EDITOR=vim
export GPG_TTY=$(tty)
export LESSHISTFILE=/dev/null

# ls colors
if [ -x `which dircolors` ]; then
  eval `dircolors -b` && \
  export ZLS_COLORS=$LS_COLORS
fi

# sudo mask
(( EUID != 0 )) && SUDO='sudo' || SUDO=''

# standard flags
ls_options=( --color=auto )
grep_options=( --color=auto )
mktemp_options=()

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
