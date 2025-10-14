abbr -ag v nvim
abbr -ag vs nvim -S Session.vim

function find-session
  pushd ~/Code
  if set -l sel $(fd -Is 'Session.vim' | xargs dirname | sk)
    cd $sel
    nvim -S Session.vim
    popd
  else
    popd
  end
end

abbr -ag fs find-session
