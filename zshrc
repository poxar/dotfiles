
#
# zshrc
# Maintainer:	Philipp Millar <philipp.millar@gmx.de>
#

source $HOME/.zsh/environment
source $HOME/.zsh/settings
source $HOME/.zsh/prompt
source $HOME/.zsh/history
source $HOME/.zsh/completion
source $HOME/.zsh/keys
source $HOME/.zsh/aliases
source $HOME/.zsh/functions

if [ -f "/usr/lib/stderred.so" ]; then
    export LD_PRELOAD="/usr/lib/stderred.so"
fi

# vim:set sw=4 foldmethod=marker ft=zsh:
