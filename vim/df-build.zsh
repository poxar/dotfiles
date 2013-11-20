
#
# vim/df-build.zsh
# clone vimfiles and link them
#

vim_dir=$target/.vim
git_url='https://github.com/poxar/vimfiles'

build_vim() {
  clone_git "vim" $git_url $vim_dir || return 1

  echo -n "make..."
  cd $vim_dir
  if ! make &>>$logfile; then
    echo "failed"
    cd -
    return 1
  fi
  cd -

  echo "done"
}

clean_vim() {
  clean_dir $vim_dir
}
