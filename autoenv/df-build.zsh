
#
# autoenv/df-build.zsh
# clone latest autoenv
#

AUTOENV_DIR=$target/.autoenv

build_autoenv() {
  check_make_env git

  if [[ -d $AUTOENV_DIR ]]; then
    echo "--- autoenv updatelog `date` ---" &>>$logfile

    echo -n "update..."
    cd $AUTOENV_DIR
    git pull &>>$logfile || {
      echo "failed!"
      cd -
      return 1
    }
    echo "done"
    cd -
  else
    echo "--- autoenv buildlog `date` ---" &>>$logfile

    echo -n "clone..."
    git clone 'https://github.com/sharat87/autoenv' "$AUTOENV_DIR" \
      &>>$logfile || {
        echo "failed!"
        return 1
      }
    echo "done"
  fi
}

clean_autoenv() {
  if [[ -d $AUTOENV_DIR ]]; then
    read -q "?Delete $AUTOENV_DIR? " && rm -rf $AUTOENV_DIR
    echo ""
  fi
}
