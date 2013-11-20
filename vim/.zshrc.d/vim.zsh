
#
# .zsh/vim.zsh
#

# call vim help page from shell prompt
function :h { vim +":h $1" +'wincmd o' +'nnoremap q :q!<CR>' ;}

# list all zle bindings in vim (for syntax highlighting)
alias help-zle='bindkey -L | vim -c "set ft=zsh" -c "set so=999" -R -'
