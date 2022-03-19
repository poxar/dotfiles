if filereadable('meson.build')
  compiler valac
  nnoremap <buffer> m<cr> :Dispatch ninja -C build<cr>
  nnoremap <buffer> mb<cr> :Dispatch meson build --prefix=/usr<cr>
endif
