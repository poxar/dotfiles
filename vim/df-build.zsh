
#
# vim/df-build.zsh
# clone vimfiles and link them
#

VIMDIR=$target/.vim

build_vim() {
  check_make_env git make

  if [[ -d $VIMDIR ]]; then
    echo "--- vim updatelog `date` ---" &>>$logfile

    echo -n "update..."
    cd $VIMDIR
    git pull &>>$logfile || {
      echo "failed!"
      cd -
      return 1
    }
    echo "done"
    cd -
  else

    echo "--- vim buildlog `date` ---" &>>$logfile

    echo -n "clone..."
    git clone 'https://github.com/poxar/vimfiles' "$VIMDIR" &>>$logfile || {
      echo "failed!"
      return 1
    }

    echo -n "make..."
    cd "$VIMDIR"
    make &>>$logfile || {
      echo "failed!"
      return 1
    }
    cd -

    echo "done"
  fi
}

clean_vim() {
  if [[ -d $VIMDIR ]]; then
    read -q "?Delete $VIMDIR? " && rm -rf $VIMDIR
    echo ""
  fi
}
