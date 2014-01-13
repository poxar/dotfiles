

#
# ~/.zsh/10-history.zsh
# settings for the history
#

HISTFILE="$HOME/.zhist"
HISTSIZE=10000
SAVEHIST=12000
HISTIGNORE="exit"

setopt share_history        # share the history over multiple instances
setopt extended_history     # put the time into history
setopt hist_ignore_all_dups # delete old duplicates
setopt hist_ignore_space    # ignore commands starting with space for history
