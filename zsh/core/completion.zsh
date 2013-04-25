
#
# .zsh/completion
#

zstyle :compinstall filename "$HOME/.zshrc"
autoload -Uz compinit && compinit
zmodload -i zsh/complist

zstyle ':completion:*' completer _complete _correct _approximate
zstyle ':completion:*:correct:::' max-errors 1 not-numeric
zstyle ':completion:*:approximate:::' max-errors 1 numeric
zstyle ':completion::complete:*' rehash true
# be colorful and informative
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' verbose yes
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format $'%{[0;31m%}%d%{[0m%}'
zstyle ':completion:*:corrections' format $'%{[0;31m%}%d%{[0m%}'
zstyle ':completion:*:messages' format $'%{[0;31m%}%d%{[0m%}'
zstyle ':completion:*:warnings' format $'%{[0;31m%}%d%{[0m%}'
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
zstyle ':completion:*:manuals.*' insert-sections true
zstyle ':completion:*:man:*' menu yes select
# list processes when completing "kill"
zstyle ':completion:*:kill:*' command 'ps xf -u $USER -o pid,%cpu,cmd'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;32'
# don't suggest files/pids that are already on the line (for rm, kill and diff)
zstyle ':completion:*:(rm|kill|diff):*' ignore-line yes
