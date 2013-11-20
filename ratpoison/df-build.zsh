
#
# ratpoison/df-build.zsh
# clone zsh-completions-ratpoison
#

COMPLETION_DIR=$target/.zsh-completion-ratpoison

build_ratpoison() {
  check_make_env git

  if [[ -d $COMPLETION_DIR ]]; then
    echo "--- ratpoison updatelog `date` ---" &>>$logfile

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

    echo "--- ratpoison buildlog `date` ---" &>>$logfile

    echo -n "clone..."
    git clone 'https://github.com/ivoarch/zsh-completion-ratpoison' "$COMPLETION_DIR" \
    &>>$logfile || {
      echo "failed!"
      return 1
    }

    echo -n "setup..."
    mkdir -p $target/.zshrc.d
    echo "fpath+=($COMPLETION_DIR)" > $target/.zshrc.d/zsh-completion-ratpoison.zsh

    echo "done"
  fi
}

clean_ratpoison() {
  if [[ -d $COMPLETION_DIR ]]; then
    read -q "?Delete $COMPLETION_DIR? " && \
      rm -rf $COMPLETION_DIR $target/.zshrc.d/zsh-completion-ratpoison.zsh
    # delete .zshrc.d if empty
    rmdir $target/.zshrc.d &>/dev/null
    echo ""
  fi
}
