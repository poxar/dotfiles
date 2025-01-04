function op --description="open project"
  set dir (fd -Is 'Session.vim' ~/Code | xargs dirname | sk)
  test -z "$dir" && return
  cd $dir
  nvim -S Session.vim
end
