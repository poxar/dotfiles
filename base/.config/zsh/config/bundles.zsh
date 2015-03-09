# additional completions
zsh_plug 'zsh-users/zsh-completions' \
  fpath src

# syntax highlighting
zsh_plug 'zsh-users/zsh-syntax-highlighting' \
  source zsh-syntax-highlighting.zsh

ZSH_HIGHLIGHT_STYLES[precommand]="fg=green,bold"
ZSH_HIGHLIGHT_STYLES[path]="fg=blue,bold"
ZSH_HIGHLIGHT_STYLES[path_prefix]="fg=blue,bold"
ZSH_HIGHLIGHT_STYLES[path_approx]="fg=yellow,bold"
ZSH_HIGHLIGHT_STYLES[globbing]="fg=cyan,bold"
ZSH_HIGHLIGHT_STYLES[history-expansion]="fg=cyan,bold"

# fish like substring search
zsh_plug 'zsh-users/zsh-history-substring-search' \
  source 'zsh-history-substring-search.zsh'

bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
