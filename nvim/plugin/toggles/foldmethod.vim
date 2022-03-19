" Easily switch between different fold methods.
" This is a slightly modified version of ficklefold.

function! s:ToggleFold()
  if !exists('b:fold_toggle_options')
    " By default, use the main three. I rarely use custom
    " expressions or manual and diff is just for diffing.
    let b:fold_toggle_options = ['syntax', 'indent', 'marker']
  endif

  " Find the current setting in the list
  let l:i = match(b:fold_toggle_options, &foldmethod)

  " Advance to the next setting
  let l:i = (l:i + 1) % len(b:fold_toggle_options)
  let &l:foldmethod = b:fold_toggle_options[l:i]

  echo 'foldmethod is now ' . &l:foldmethod
endfunction

function! s:FoldParagraphs()
  setlocal foldmethod=expr
  setlocal fde=getline(v:lnum)=~'^\\s*$'&&getline(v:lnum+1)=~'\\S'?'<1':1
endfunction

command! FoldToggle call <SID>ToggleFold()
command! FoldParagraphs call <SID>FoldParagraphs()

nnoremap yof :FoldToggle<cr>
