if filereadable('Cargo.toml')
  compiler cargo

  nnoremap <buffer> m<cr> :Make check<cr>
  nnoremap <buffer> <space>ml :Make clippy<cr>
  nnoremap <buffer> <space>mc :Make clean<cr>
  nnoremap <buffer> <space>mb :Make build<cr>
  nnoremap <buffer> <space>mf :Make fmt<cr>
  nnoremap <buffer> <space>mr :Start -wait=never cargo run<cr>
  nnoremap <buffer> <space>md :Termdebug target/debug/

  setlocal path+=./src

  let g:termdebugger = "rust-gdb"
  packadd termdebug
endif

let g:rust_fold = 0
let g:rust_bang_comment_leader = 1

let g:rustfmt_autosoave = 1
let g:rustfmt_fail_silently = 0
