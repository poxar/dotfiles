
#
# zshrc
# Maintainer:	Philipp Millar <philipp.millar@gmx.de>
#

source $HOME/.zsh/environment
source $HOME/.zsh/settings
source $HOME/.zsh/prompt
source $HOME/.zsh/history
source $HOME/.zsh/completion
source $HOME/.zsh/zle
source $HOME/.zsh/aliases
source $HOME/.zsh/functions

# text objects and surroundings for vi-mode
# https://github.com/hchbaw/opp.zsh
OPPZSH=$HOME/.zsh/opp.zsh
if [[ -d $OPPZSH ]]; then
    source $OPPZSH/opp.zsh
    source $OPPZSH/opp/*
fi

# vim:set sw=4 foldmethod=marker ft=zsh:
