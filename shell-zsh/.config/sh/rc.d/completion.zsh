autoload -Uz compinit
zmodload -i zsh/complist

zstyle ':completion:*' completer _complete
zstyle ':completion::complete:*' rehash true
# be colorful and informative
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' verbose yes
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format $'%{[0;31m%}%d%{[0m%}'
zstyle ':completion:*:messages' format $'%{[0;31m%}%d%{[0m%}'
zstyle ':completion:*:warnings' format $'%{[0;31m%}%d%{[0m%}'
# also suggest completions that don't start with the typed string
zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
# ignore some files and completions for programs we don't have
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*:(all-|)files' ignored patterns "(*.BAK|*.bak|*.o|*.aux|*.toc|*.swp|*~)"
# ignore nothing, when completing rm
zstyle ':completion:*:rm:*:(all-|)files' ignored patterns
# completion menu
zstyle ':completion:*' menu select=2
zstyle ':completion:*:default' select-prompt '%SMatch %M    %P%s'
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
# automatically complete 'cd -<tab>' and 'cd -<ctrl-d>' with menu
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
# expand global aliases
zstyle ':completion:*:expand-alias:*' global true
# insert/complete sections for man pages
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.*' insert-sections false
zstyle ':completion:*:man:*' menu yes select
# list processes when completing "kill"
zstyle ':completion:*:kill:*' command 'ps xf -u $USER -o pid,%cpu,cmd'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;32'
# don't suggest files/pids that are already on the line (for rm, kill and diff)
zstyle ':completion:*:(rm|kill|diff):*' ignore-line yes

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

# load custom completions
fpath+=("${ZCOMPDIR:-"$XDG_DATA_HOME/zsh/completion"}")

mkdir -p "$XDG_DATA_HOME/zsh"
compinit -d "$XDG_DATA_HOME/zsh/zcompdump"

compdef g='git'
