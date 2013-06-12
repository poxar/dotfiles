

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
setopt hist_no_store        # don't save history commands
setopt hist_reduce_blanks   # delete unneeded blanks
setopt hist_ignore_all_dups # never duplicate entries
setopt hist_ignore_space    # ignore commands starting with space for history
setopt hist_verify          # show history-completed commands before execution
