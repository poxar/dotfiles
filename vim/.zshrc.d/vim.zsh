
#
# .zsh/vim.zsh
#

# call vim help page from shell prompt
function :h { vim +":h $1" +'wincmd o' +'nnoremap q :q!<CR>' ;}
