if filereadable('Cargo.toml')
  compiler cargo

  nnoremap <buffer> m<cr> :Make check<cr>
  nnoremap <buffer> <leader>ml :Make clippy<cr>
  nnoremap <buffer> <leader>mc :Make clean<cr>
  nnoremap <buffer> <leader>mb :Make build<cr>
  nnoremap <buffer> <leader>mf :Make fmt<cr>
  nnoremap <buffer> <leader>mr :Start -wait=never cargo run<cr>
  nnoremap <buffer> <leader>md :Termdebug target/debug/

  nnoremap <buffer> <leader>ec :edit Cargo.toml<cr>

  command -buffer Doc :Make doc --open

  setlocal path+=./src

  let g:termdebugger = "rust-gdb"
  packadd termdebug
endif

let g:rust_fold = 0
let g:rust_bang_comment_leader = 1

let g:rustfmt_autosoave = 1
let g:rustfmt_fail_silently = 0
