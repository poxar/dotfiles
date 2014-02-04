
#
# .zsh/11-zle-abbreviations.zsh
#

typeset -A abbreviations
abbreviations=(
  "Il"  "| ${PAGER:-less}"
  "Ia"  "| awk"
  "Ig"  "| grep"
  "Igg" "| ag"
  "Ih"  "| head"
  "It"  "| tail"
  "If"  "| tail -f"
  "Is"  "| sort"
  "Iv"  "| ${VISUAL:-${EDITOR}}"
  "Ie"  "| ${VISUAL:-${EDITOR}}"
  "Iw"  "| wc"
  "Ic"  "| wc -l"
  "Ix"  "| xargs"
  "NE"  "2>|/dev/null"
  "NO"  "&>|/dev/null"
  "Hl"  " --help |& ${PAGER:-less} -r"
)

# expand abbreviations
magic-abbrev-expand() {
    local MATCH
    LBUFFER=${LBUFFER%%(#m)[.-|_a-zA-Z0-9]#}
    LBUFFER+=${abbreviations[$MATCH]:-$MATCH}
    zle magic-space
}
no-magic-abbrev-expand() { LBUFFER+=' ' }
zle -N magic-abbrev-expand
zle -N no-magic-abbrev-expand

# show abbreviations
help-show-abbrev() { zle -M "$(print -a -C 2 ${(kv)abbreviations})" }
zle -N help-show-abbrev

bindkey -M emacs ' '   magic-abbrev-expand
bindkey -M emacs '^S ' no-magic-abbrev-expand
bindkey -M emacs '^S?' help-show-abbrev

bindkey -M viins ' ' magic-abbrev-expand
bindkey -M viins '^X ' no-magic-abbrev-expand
bindkey -M viins '^X?' help-show-abbrev

bindkey -M isearch ' ' self-insert
