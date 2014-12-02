
#
# ~/.zshrc
# set up the configuration framework
#

# defaults
export PATH="$HOME/.local/bin:$PATH"
export EDITOR=vim
export GPG_TTY=$(tty)
export XDG_CONFIG_HOME="$HOME/.config"
export ZCONFDIR="$XDG_CONFIG_HOME/zsh"

# configuration directories
ZSHRCD=$ZCONFDIR/config
ZLOGIND=$ZCONFDIR/login
ZLOGOUTD=$ZCONFDIR/logout
ZCOMPLETE=$ZCONFDIR/completions
ZFUNCTION=$ZCONFDIR/functions
ZBUNDLE=$ZCONFDIR/bundle
HELPDIR=$ZCONFDIR/help

fpath=($ZCOMPLETE $fpath)
fpath=($ZFUNCTION $fpath)

# sudo mask
(( EUID != 0 )) && SUDO='sudo' || SUDO=''

# load configuration files
for zfile in $ZSHRCD/*.zsh; do; source $zfile; done
unset zfile

# autoload functions
for zfunc in $ZFUNCTION/*; do; autoload -Uz $(basename $zfunc); done
unset zfunc

# automatically remove duplicates
typeset -U path cdpath fpath manpath

unset SUDO
