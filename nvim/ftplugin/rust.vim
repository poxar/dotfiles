nnoremap gK :silent !open dash://rust:<cword><cr>

if filereadable('Cargo.toml')
  compiler cargo

  nnoremap <buffer> m<cr> :Make check<cr>
  nnoremap <buffer> ml<cr> :Make clippy<cr>
  nnoremap <buffer> mc<cr> :Make clean<cr>
  nnoremap <buffer> mb<cr> :Make build<cr>
  nnoremap <buffer> mf<cr> :Make fmt<cr>
  nnoremap <buffer> mt<cr> :Make test<cr>
  nnoremap <buffer> md<cr> :Make doc --open<cr>
  nnoremap <buffer> mr<cr> :Start -wait=never cargo run<cr>
  nnoremap <buffer> mD<cr> :Termdebug target/debug/

  setlocal path+=./src
endif

let g:rust_fold = 0
let g:rust_bang_comment_leader = 1
let g:ftplugin_rust_source_path = $RUST_SRC_PATH

let g:rustfmt_autosoave = 1
let g:rustfmt_fail_silently = 0
