
#
# base/df-build.zsh
# clone zsh-completions
#

COMPLETION_DIR=$target/.zsh-completion

build_base() {
  check_make_env git

  if [[ -d $COMPLETION_DIR ]]; then
    echo "--- base updatelog `date` ---" &>>$logfile

    echo -n "update..."
    cd $COMPLETION_DIR
    git pull &>>$logfile || {
      echo "failed!"
      cd -
      return 1
    }
    echo "done"
    cd -
  else

    echo "--- base buildlog `date` ---" &>>$logfile

    echo -n "clone..."
    git clone 'https://github.com/zsh-users/zsh-completions' "$COMPLETION_DIR" \
    &>>$logfile || {
      echo "failed!"
      return 1
    }

    echo -n "setup..."
    mkdir -p $target/.zshrc.d
    echo "fpath+=($COMPLETION_DIR/src)" > $target/.zshrc.d/zsh-completions.zsh

    echo "done"
  fi
}

clean_base() {
  if [[ -d $COMPLETION_DIR ]]; then
    read -q "?Delete $COMPLETION_DIR? " && \
      rm -rf $COMPLETION_DIR $target/.zshrc.d/zsh-completion.zsh
    # delete .zshrc.d if empty
    rmdir $target/.zshrc.d &>/dev/null
    echo ""
  fi
}
