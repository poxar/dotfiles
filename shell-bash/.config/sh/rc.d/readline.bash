set -o emacs

# Unbind some keys from stty
stty -ixon        # C-q/C-s
stty susp undef   # C-z
stty werase undef # C-w

# quickly add sudo to command line
__rl_sudo() {
  if echo "$READLINE_LINE" | grep -q '^sudo '; then
    READLINE_POINT=$((READLINE_POINT - 5))
    READLINE_LINE=${READLINE_LINE:5}
  else
    READLINE_LINE="sudo $READLINE_LINE"
    READLINE_POINT=$((READLINE_POINT + 5))
  fi
}
bind -m emacs -x '"\C-s":"__rl_sudo"'
bind -m vi-insert -x '"\C-s":"__rl_sudo"' 

# run last command with sudo
__rl_fixup() {
  if test -z "$READLINE_LINE"; then
    READLINE_LINE="sudo $(fc -ln -1 | sed 's/^\t //')"
    READLINE_POINT=${#READLINE_LINE}
  fi
}
bind -m emacs -x '"\es":"__rl_fixup"'
bind -m vi-command -x '"!!":"__rl_fixup"'
bind -m vi-insert -x '"\C-f":"__rl_fixup"'

# expands ... to ../..
__rl_magic_dot() {
  prefix=${READLINE_LINE:0:$READLINE_POINT}
  postfix=${READLINE_LINE:$READLINE_POINT}

  if test "${READLINE_LINE:$(( READLINE_POINT - 2 )):2}" = '..'; then
    READLINE_LINE="$prefix/..$postfix"
    READLINE_POINT=$(( READLINE_POINT + 3 ))
  else
    READLINE_LINE="$prefix.$postfix"
    READLINE_POINT=$(( READLINE_POINT + 1 ))
  fi

  unset prefix
  unset postfix
}
bind -m emacs -x '".":"__rl_magic_dot"'
bind -m vi-insert -x '".":"__rl_magic_dot"'

# bring last bg process back up
bind -m emacs '"\C-z":"\C-e\C-ufg\n"'
bind -m vi-insert '"\C-z":"\eccfg\n\epA"'

# Jump after the first word
bind -m emacs '"\ea":"\C-a\ef"'
bind -m vi-command '"I":"0ea"'

# automatically expand history substitutions on space
# (rebond from .inputrc to enable in all modes)
bind -m emacs '" ":magic-space'
bind -m vi-insert '" ":magic-space'

# history search (rebond from .inputrc to enable in all modes)
bind -m emacs '"\[p":previous-history'
bind -m emacs '"\[n":next-history'
bind -m emacs '"\C-p":history-search-backward'
bind -m emacs '"\C-n":history-search-forward'
bind -m vi-insert '"\C-p":history-search-backward'
bind -m vi-insert '"\C-n":history-search-forward'
bind -m vi-command '"gk":history-search-backward'
bind -m vi-command '"gj":history-search-forward'

# consider / a word boundary (rebond from .inputrc to enable in all modes)
bind -m emacs '"\C-w":unix-filename-rubout'
bind -m vi-insert '"\C-w":unix-filename-rubout'
bind -m emacs '"\C-b":shell-backward-word'
bind -m emacs '"\C-f":shell-forward-word'

# vim style
bind -m vi-command '"gg":beginning-of-history'
bind -m vi-command '"G":end-of-history'

# clear screen
bind -m vi-insert '"\C-l":clear-screen'

# inline abbreviations
abbreviations=(
  '"|l":"| less"'
  '"|a":"| awk"'
  '"|g":"| grep "'
  '"|h":"| head"'
  '"|t":"| tail"'
  '"|f":"| tail -f"'
  '"|s":"| sort"'
  '"|w":"| wc"'
  '"|x":"| xargs "'
  '"|c":"| clipboard"'
  '">E":"2>/dev/null"'
  '">N":">/dev/null"'
  '">O":">/dev/null 2>&1"'
)

for abb in "${abbreviations[@]}"; do
  bind -m emacs "$abb"
  bind -m vi-insert "$abb"
done

unset abbreviations
