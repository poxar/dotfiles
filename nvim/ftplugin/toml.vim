" I duplicate my rust config for dispatch here, since I quite often want
" to run cargo stuff when editing Cargo.toml
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
