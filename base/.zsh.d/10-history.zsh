

#
# ~/.zsh/10-history.zsh
# settings for the history
#

HISTFILE="$HOME/.zhist"
HISTSIZE=20000
SAVEHIST=20000
HISTIGNORE="exit"

setopt hist_ignore_all_dups # delete old duplicates
setopt hist_ignore_space    # ignore commands starting with space for history
setopt hist_lex_words       # parse history files correctly
setopt inc_append_history   # append to the histfile directly

unsetopt share_history      # don't share the history automatically
unsetopt extended_history   # use the simple history format

# manually sync the history between instances
alias histsync="fc -RI"
