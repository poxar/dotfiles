
#
# ~/.zshrc
# initializes some variables and loads configuration files
#

ZDIR=$HOME/.zsh

# function to add stuff to path
function addToPath() {
for i in $@; do
  if ! echo $PATH | grep "$i:" >/dev/null; then
    [[ -d $i ]] && PATH=$i:$PATH
  fi
done
export PATH
}

addToPath "$HOME/bin"
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

unset SUDO
unset grep_options
unset ls_options
unset mktemp_options
