
#
# vim/df-build.zsh
# clone vimfiles and link them
#

build_vim() {
  check_make_env git make

  if [[ -d $target/.vim ]]; then
    echo "up to date"
  else

    echo "--- vim buildlog `date` ---" &>>$logfile

    echo -n "clone..."
    git clone 'https://github.com/poxar/vimfiles' "$target/.vim" &>>$logfile || {
      echo "failed!"
      return 1
    }

    echo -n "make..."
    cd "$target/.vim"
    make &>>$logfile || {
      echo "failed!"
      return 1
    }
    cd -

    echo "done"
  fi
}

clean_vim() {
  if [[ -d $target/.vim ]]; then
    read -q "?Delete $target/.vim? " && rm -rf $target/.vim
    echo ""
  fi
}
