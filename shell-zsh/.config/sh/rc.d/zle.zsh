bindkey -e

WORDCHARS='-*?_[]~=&!$%^(){}'

# open commandline in editor
autoload -U edit-command-line
zle -N edit-command-line
bindkey -M emacs '^X^E' edit-command-line
bindkey -M vicmd 'v' edit-command-line

# get quick help for current command
unalias run-help
autoload -Uz run-help
autoload -Uz run-help-git
autoload -Uz run-help-ip
autoload -Uz run-help-openssl
autoload -Uz run-help-sudo
autoload -Uz run-help-svn
bindkey -M emacs '^[/' run-help
bindkey -M vicmd 'K' run-help

# proper bracketed paste
autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic

# quickly insert filenames
autoload -Uz insert-files
zle -N insert-files
bindkey -M emacs '^Xf' insert-files

# predictive typing
autoload -Uz predict-on
zle -N predict-on
zle -N predict-off
bindkey '^X^Z' predict-on
bindkey '^Xz' predict-off

# prepend sudo or remove it if present
run-with-sudo() {
  if [[ $LBUFFER[(w)1] == 'sudo' ]]
  then
    LBUFFER="${LBUFFER##sudo }"
  else
    LBUFFER="sudo ${LBUFFER}"
  fi
}
zle -N run-with-sudo
bindkey -M emacs '^S' run-with-sudo
bindkey -M vicmd '^S' run-with-sudo
bindkey -M viins '^S' run-with-sudo

# replace current command line with (expanded) sudo !!
# save the current line in the buffer stack
run-last-with-sudo() {
  if [[ $LBUFFER[(w)1] != 'sudo' ]]; then
    zle .push-input
  fi
  zle up-history
  if [[ $LBUFFER[(w)1] != 'sudo' ]]; then
    LBUFFER="sudo $LBUFFER"
  fi
}
zle -N run-last-with-sudo
bindkey -M emacs '^[s' run-last-with-sudo
bindkey -M vicmd '!!' run-last-with-sudo
bindkey -M viins '^F' run-last-with-sudo

# Expands .... to ../..
magic-dot() {
  if [[ $LBUFFER = *.. ]]; then
    LBUFFER+='/..'
  else
    LBUFFER+='.'
  fi
}
zle -N magic-dot
bindkey -M emacs "." magic-dot
bindkey -M viins "." magic-dot
bindkey -M isearch "." self-insert

# jump after first word (to add switches)
after-first-word() {
  zle beginning-of-line
  zle forward-word
  [[ $LBUFFER[(w)1] == 'sudo' ]] && zle forward-word
  zle backward-char
}
zle -N after-first-word
vi-after-first-word() {
  zle after-first-word
  zle vi-insert
  LBUFFER+=' '
}
zle -N vi-after-first-word
bindkey -M emacs '^[a' after-first-word
bindkey -M vicmd 'I' vi-after-first-word

# quickly put job to foreground
grml-zsh-fg() {
  if (( ${#jobstates} )); then
    zle .push-input
    [[ -o hist_ignore_space ]] && BUFFER=' ' || BUFFER=''
    BUFFER="${BUFFER}fg"
    zle .accept-line
  else
    zle -M 'No background jobs. Doing nothing.'
  fi
}
zle -N grml-zsh-fg
bindkey -M emacs '^Z' grml-zsh-fg
bindkey -M vicmd '^Z' grml-zsh-fg
bindkey -M viins '^Z' grml-zsh-fg

# automatically expand history substitutions on space
bindkey -M emacs ' ' magic-space
bindkey -M viins ' ' magic-space

# quick history search
bindkey -M emacs '^[p' up-history
bindkey -M emacs '^[n' down-history

bindkey -M emacs '^P' history-beginning-search-backward
bindkey -M emacs '^N' history-beginning-search-forward
bindkey -M viins '^P' history-beginning-search-backward
bindkey -M viins '^N' history-beginning-search-forward

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey -M vicmd 'j' down-line-or-beginning-search
bindkey -M vicmd 'k' up-line-or-beginning-search
bindkey -M vicmd 'gj' down-line-or-history
bindkey -M vicmd 'gk' up-line-or-history

# quick help
bindkey -M emacs '^Xh'  where-is
bindkey -M emacs '^X^H' describe-key-briefly
bindkey -M viins '^_' describe-key-briefly
bindkey -M emacs '^_' describe-key-briefly

# control arrow keys
bindkey -M emacs ';5D' backward-word
bindkey -M emacs ';5C' forward-word
bindkey -M viins ';5D' backward-word
bindkey -M viins ';5C' forward-word

#
# emacs
#

# simple redo
bindkey -M emacs '^X^R' redo
# use patterns for search
bindkey -M emacs '^R'  history-incremental-pattern-search-backward
# use ^E^U to kill the whole line
bindkey -M emacs '^U' backward-kill-line
# drop into vi mode
bindkey -M emacs 'jk' vi-cmd-mode

#
# vi command mode
#

bindkey -M vicmd 'gg' beginning-of-history
bindkey -M vicmd 'G'  vi-fetch-history

# swap the search directions and add pattern search
bindkey -M vicmd '/'  history-incremental-pattern-search-backward
bindkey -M vicmd '?'  history-incremental-pattern-search-forward

# vim-like undo
bindkey -M vicmd 'u'  undo
bindkey -M vicmd '^R' redo

# make Y consistent
bindkey -M vicmd 'Y'  vi-yank-eol
bindkey -M vicmd 'yy' vi-yank-whole-line

#
# vi insert mode
#

# those are annoying
bindkey -rM viins "^[,"
bindkey -rM viins "^[/"
bindkey -rM viins "^[~"

# backspace over everything
bindkey -M viins "^?" backward-delete-char
bindkey -M viins "^H" backward-delete-char
bindkey -M viins "^W" backward-kill-word
bindkey -M viins "^U" backward-kill-line

# preserve some readline bindings
bindkey -M viins "^A" beginning-of-line
bindkey -M viins "^E" end-of-line
bindkey -M viins "^R" history-incremental-pattern-search-backward

# insert last word
bindkey -M viins '^[.' insert-last-word

#
# abbreviatons
#

typeset -A abbreviations
abbreviations=(
  '|l' '| less'
  '|a' '| awk'
  '|g' '| grep '
  '|h' '| head'
  '|t' '| tail'
  '|f' '| tail -f'
  '|s' '| sort'
  '|w' '| wc'
  '|x' '| xargs '
  '|c' '| clipboard'
  '>E' '2>/dev/null'
  '>N' '>/dev/null'
  '>O' '&>/dev/null'
)

expand_abbreviation() {
  LBUFFER+="${abbreviations[$KEYS]}"
}
zle -N expand_abbreviation

for abb in "${(k)abbreviations[@]}"; do
  bindkey -M emacs $abb expand_abbreviation
  bindkey -M viins $abb expand_abbreviation
done
