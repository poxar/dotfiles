
#
# ~/.zshrc
# set up the configuration framework
#

# defaults
export PATH="$HOME/bin:$PATH"
export EDITOR=vim
export GPG_TTY=$(tty)
export LESSHISTFILE=/dev/null
fpath=($HOME/.zpath $fpath)
fpath=($HOME/.zcomp/src $fpath)

# configuration directories
ZSHRCD=$HOME/.zsh.d
ZLOGIND=$HOME/.zlogin.d
ZLOGOUTD=$HOME/.zlogout.d

HELPDIR=$HOME/.zhelp

# sudo mask
(( EUID != 0 )) && SUDO='sudo' || SUDO=''

# load configuration files
for zfile in $ZSHRCD/*.zsh; do; source $zfile; done
unset zfile

# automatically remove duplicates
typeset -U path cdpath fpath manpath

unset SUDO
