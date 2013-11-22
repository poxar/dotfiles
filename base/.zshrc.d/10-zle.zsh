
#
# .zsh/10-zle.zsh
# configure the behaviour of the zsh line editor
#

# use emacs bindings and vim for heavy editing
bindkey -e

autoload -U url-quote-magic   # quote pasted urls
autoload -U edit-command-line # edit commandline in editor

if [[ -d $HELPDIR ]]; then
    unalias run-help
    autoload -U run-help
fi

zle -N edit-command-line
zle -N self-insert url-quote-magic

WORDCHARS='*?_[]~=&;!#$%^(){}'

# zle functions {{{
# prepend sudo or remove it if present
run-with-sudo() {
    if [[ $LBUFFER[(w)1] == 'sudo' ]]
    then # found sudo, strip it
        LBUFFER="${LBUFFER##sudo }"
    else # no sudo, so prepend it
        LBUFFER="sudo ${LBUFFER}"
    fi
}
zle -N run-with-sudo

typeset -A abbreviations
abbreviations=(
  "..."   "../.."
  "...."  "../../.."
  "....." "../../../.."
  "Il"    "| ${PAGER:-less}"
  "Ia"    "| awk"
  "Ig"    "| grep"
  "Igg"   "| ag"
  "Ih"    "| head"
  "It"    "| tail"
  "If"    "| tail -f"
  "Is"    "| sort"
  "Iv"    "| ${VISUAL:-${EDITOR}}"
  "Ie"    "| ${VISUAL:-${EDITOR}}"
  "Iw"    "| wc"
  "Ic"    "| wc -l"
  "Ix"    "| xargs"
  "NE"   "2>|/dev/null"
  "NO"   "&>|/dev/null"
  "Hl"    " --help |& ${PAGER:-less} -r"
)

magic-abbrev-expand() {
    local MATCH
    LBUFFER=${LBUFFER%%(#m)[.-|_a-zA-Z0-9]#}
    LBUFFER+=${abbreviations[$MATCH]:-$MATCH}
    zle magic-space
}
zle -N magic-abbrev-expand

no-magic-abbrev-expand() { LBUFFER+=' ' } 
zle -N no-magic-abbrev-expand

help-show-abbrev() { zle -M "$(print -a -C 2 ${(kv)abbreviations})" }
zle -N help-show-abbrev

after-first-word() {
    zle beginning-of-line
    zle vi-forward-blank-word
    [[ $LBUFFER[(w)1] == 'sudo' ]] && \
        zle vi-forward-blank-word
    zle backward-char
    LBUFFER+=' '
}
zle -N after-first-word

mquote() {
    zle beginning-of-line
    zle forward-word
    RBUFFER=${(q)RBUFFER}
    zle end-of-line
}
zle -N mquote

function insert-date() { LBUFFER+=${(%):-'%D{%Y-%m-%d}'}; }
zle -N insert-date

function grml-zsh-fg() {
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
#}}}
# fix special keys {{{
# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key

key[Home]=${terminfo[khome]}

key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# setup key accordingly
[[ -n "${key[Home]}"     ]]  && bindkey  "${key[Home]}"     beginning-of-line
[[ -n "${key[End]}"      ]]  && bindkey  "${key[End]}"      end-of-line
[[ -n "${key[Insert]}"   ]]  && bindkey  "${key[Insert]}"   overwrite-mode
[[ -n "${key[Delete]}"   ]]  && bindkey  "${key[Delete]}"   delete-char
[[ -n "${key[Up]}"       ]]  && bindkey  "${key[Up]}"       up-line-or-history
[[ -n "${key[Down]}"     ]]  && bindkey  "${key[Down]}"     down-line-or-history
[[ -n "${key[Left]}"     ]]  && bindkey  "${key[Left]}"     backward-char
[[ -n "${key[Right]}"    ]]  && bindkey  "${key[Right]}"    forward-char
[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"   history-beginning-search-backward
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}" history-beginning-search-forward

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        printf '%s' ${terminfo[smkx]}
    }
    function zle-line-finish () {
        printf '%s' ${terminfo[rmkx]}
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi
#}}}

# emacs {{{
# clear ^S we'll use it as prefix
bindkey -rM emacs '^S'

# fixes
bindkey -M emacs '^X^R' redo
bindkey -M emacs '^[p'  history-beginning-search-backward
bindkey -M emacs '^[n'  history-beginning-search-forward
# use patterns for search
bindkey -M emacs '^R'  history-incremental-pattern-search-backward
bindkey -M emacs '^Sr' history-incremental-pattern-search-forward
# use ^E^U to kill the whole line
bindkey -M emacs '^U' backward-kill-line
# quick help
bindkey -M emacs '^Sh'  where-is
bindkey -M emacs '^S^H' describe-key-briefly
# comment out current line
bindkey -M emacs '^S#' pound-insert
# push everything on the stack
bindkey -M emacs '^Sq' push-input
# quote everything after the cursor
bindkey -M emacs '^SQ' mquote

# easier history navigation
bindkey -M emacs '^SG' end-of-history
bindkey -M emacs '^Sg' beginning-of-history

# prefix bindings
# prepend sudo
bindkey -M emacs '^Ss'  run-with-sudo
bindkey -M emacs '^S^S' run-with-sudo

# add arguments
bindkey -M emacs '^S^A' after-first-word
bindkey -M emacs '^Sa'  after-first-word

# edit command in vim
bindkey -M emacs '^Sv'  edit-command-line
bindkey -M emacs '^S^V' edit-command-line

# easier on the fingers
bindkey -M emacs '^S.' copy-prev-word

# magic space
bindkey -M emacs ' '   magic-abbrev-expand
bindkey -M emacs '^S ' no-magic-abbrev-expand
bindkey -M emacs '^S?' help-show-abbrev

# insert date from grml.org
bindkey -M emacs '^Sd'  insert-date
bindkey -M emacs '^S^D' insert-date

# foreground from grml.org
bindkey -M emacs '^Z' grml-zsh-fg
#}}}
# vi command mode {{{
bindkey -M vicmd 'gg' beginning-of-history
bindkey -M vicmd 'G'  end-of-history

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

# preserve some readline bindings
bindkey -M viins "^A" beginning-of-line
bindkey -M viins "^E" end-of-line
bindkey -M viins '^R' history-incremental-pattern-search-backward
bindkey -M viins '^Q' push-input
bindkey -M viins '^P' history-beginning-search-backward
bindkey -M viins '^N' history-beginning-search-forward  

# quick undo/redo
bindkey -M viins '^Z' undo
bindkey -M viins '^Y' redo

# add sudo
bindkey -M viins '^S' run-with-sudo

# insert last word
bindkey -M viins '^K' insert-last-word

# magic space
bindkey -M viins ' ' magic-abbrev-expand
bindkey -M viins '^X ' no-magic-abbrev-expand
# }}}
# misc {{{
# menu navigation
bindkey -M menuselect 'h' backward-char
bindkey -M menuselect 'j' down-line-or-history
bindkey -M menuselect 'k' up-line-or-history
bindkey -M menuselect 'l' forward-char
# insert, but accept further completions
bindkey -M menuselect 'i' accept-and-menu-complete
# insert, and show menu with further possible completions
# useful for cd-ing into nested directories
bindkey -M menuselect 'o' accept-and-infer-next-history
# undo
bindkey -M menuselect 'u' undo
# magic space
bindkey -M isearch ' ' self-insert
# }}}
