if filereadable('Cargo.toml')
  compiler cargo

  nnoremap <buffer> m<cr> :Make check<cr>
  nnoremap <buffer> <leader>ml :Make clippy<cr>
  nnoremap <buffer> <leader>mc :Make clean<cr>
  nnoremap <buffer> <leader>mb :Make build<cr>
  nnoremap <buffer> <leader>mf :Make fmt<cr>
  nnoremap <buffer> <leader>mt :Make test<cr>
  nnoremap <buffer> <leader>mr :Start -wait=always cargo run<cr>

  nnoremap <buffer> <leader>ec :edit Cargo.toml<cr>

  command -buffer Doc :Make doc --open

  setlocal path+=./src
endif

let g:rust_fold = 0
let g:rust_bang_comment_leader = 1

let g:rustfmt_autosave = 1
let g:rustfmt_fail_silently = 0
