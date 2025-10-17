let g:rust_bang_comment_leader = 1

if filereadable('Cargo.toml')
  compiler cargo

  let b:dispatch = 'cargo check'
  let b:dispatch_test = 'cargo test'

  let b:dispatch_targets = [
        \ "cargo check",
        \ "cargo build",
        \ "cargo test",
        \ "cargo bench",
        \ ]

  nnoremap <buffer> <leader>ec :edit Cargo.toml<cr>
  command -buffer Doc :Make doc --open

  setlocal path+=./src
endif
