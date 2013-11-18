
#
# ~/.zshrc
# set up the configuration framework
#

export EDITOR=vim
export LESSHISTFILE=/dev/null

# sudo mask
(( EUID != 0 )) && SUDO='sudo' || SUDO=''

# load configuration files
for zfile in $ZSHRCD/*.zsh; do; source $zfile; done
unset zfile

# automatically remove duplicates
typeset -U path cdpath fpath manpath

unset SUDO
