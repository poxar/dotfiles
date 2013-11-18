
#
# ~/.zshrc
# initializes some variables and loads configuration files
#

ZDIR=$HOME/.zshrc.d

export PATH="$HOME/bin:$PATH"
export EDITOR=vim
export GPG_TTY=$(tty)
export LESSHISTFILE=/dev/null

# sudo mask
(( EUID != 0 )) && SUDO='sudo' || SUDO=''

# custom completion and function searchpath
fpath=($HOME/.zpath $fpath)

# load configuration files
for zfile in $ZDIR/*.zsh; do; source $zfile; done
unset zfile

# automatically remove duplicates
typeset -U path cdpath fpath manpath

unset SUDO
