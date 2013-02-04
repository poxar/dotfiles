
#
# .zsh/zle
# configure the behaviour of the zsh line editor
#

# use bash-style words
select-word-style bash

# prepend sudo
run-with-sudo() { LBUFFER="sudo $LBUFFER" }

typeset -Ag abbreviations
abbreviations=(
  "Il"    "| $PAGER"
  "Ia"    "| awk"
  "Ig"    "| grep"
  "Igg"   "| ag"
  "Ih"    "| head"
  "It"    "| tail"
  "Is"    "| sort"
  "Iv"    "| ${VISUAL:-${EDITOR}}"
  "Iw"    "| wc"
  "Ix"    "| xargs"
  "INE"   "2>|/dev/null"
  "INO"   "&>|/dev/null"
  "Ipwd"  "$(pwd)"
)

magic-abbrev-expand() {
    local MATCH
    LBUFFER=${LBUFFER%%(#m)[_a-zA-Z0-9]#}
    LBUFFER+=${abbreviations[$MATCH]:-$MATCH}
    zle magic-space
}

no-magic-abbrev-expand() {
  LBUFFER+=' '
}

zle -N self-insert url-quote-magic
zle -N edit-command-line

zle -N run-with-sudo
zle -N magic-abbrev-expand
zle -N no-magic-abbrev-expand

# vi command mode {{{
bindkey -M vicmd 'gg' beginning-of-history
bindkey -M vicmd 'G'  end-of-history
bindkey -M vicmd 'k'  up-line-or-search
bindkey -M vicmd 'j'  down-line-or-search 

# open man file of the current command
bindkey -M vicmd 'K' run-help

# swap the search directions and add pattern search
bindkey -M vicmd '/'  history-incremental-pattern-search-backward
bindkey -M vicmd '?'  history-incremental-pattern-search-forward

# push the whole input into the buffer stack
bindkey -M vicmd '^Q' push-input

# edit in $EDITOR
bindkey -M vicmd 'v' edit-command-line

# vim-like undo
bindkey -M vicmd 'u' undo
bindkey -M vicmd '^R' redo

# beginning/end of line
bindkey -M vicmd 'H' vi-digit-or-beginning-of-line
bindkey -M vicmd 'L' vi-end-of-line

# add sudo
bindkey -M viins '^S' run-with-sudo

# make Y consistent *sigh*
bindkey -M vicmd 'Y' vi-yank-eol
bindkey -M vicmd 'yy' vi-yank-whole-line
# }}}
# vi insert mode {{{
bindkey -M viins 'jk' vi-cmd-mode
bindkey -M viins '^F' insert-files

# preserve some readline bindings
bindkey -M viins "^W" backward-kill-word
bindkey -M viins "^A" beginning-of-line
bindkey -M viins "^E" end-of-line
bindkey -M viins '^R' history-incremental-pattern-search-backward
bindkey -M viins '^Q' push-input
bindkey -M viins '^P' history-beginning-search-backward
bindkey -M viins '^N' history-beginning-search-forward  

# arrow keys
bindkey -M viins "\e[A" up-line-or-history
bindkey -M viins "\e[B" down-line-or-history

# quick undo/redo
bindkey -M viins '^Z' undo
bindkey -M viins '^Y' redo

# add sudo
bindkey -M viins '^S' run-with-sudo

# magic space
bindkey -M viins ' ' magic-abbrev-expand
bindkey -M viins '^x ' no-magic-abbrev-expand
bindkey -M isearch ' ' self-insert

# insert last word
bindkey -M viins '^K' insert-last-word
# }}}
# completion {{{
# navigation
bindkey -M menuselect 'h' backward-char
bindkey -M menuselect 'j' down-line-or-history
bindkey -M menuselect 'k' up-line-or-history
bindkey -M menuselect 'l' forward-char
# insert, but accept further completions
bindkey -M menuselect 'i' accept-and-menu-complete
# insert, and show menu with further possible completions
bindkey -M menuselect 'o' accept-and-next-history
# undo
bindkey -M menuselect 'u' undo
# }}}

# vim:set sw=4 foldmethod=marker ft=zsh:
