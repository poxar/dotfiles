nnoremap <buffer> md<cr> :Start -wait=always ansible-playbook -i hosts site.yml
nnoremap <buffer> ml<cr> :Dispatch ansible-lint<cr>
