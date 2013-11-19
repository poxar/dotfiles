
#
# autoenv/df-build.zsh
# clone latest autoenv
#

build_autoenv() {
  check_make_env git

  if [[ -d $target/.autoenv ]]; then
    echo "up to date"
  else
    echo "--- autoenv buildlog `date` ---" &>>$logfile

    echo -n "clone..."
    git clone 'https://github.com/sharat87/autoenv' "$target/.autoenv" \
      &>>$logfile || {
        echo "failed!"
        return 1
      }
    echo "done"
  fi
}

clean_autoenv() {
  if [[ -d $target/.autoenv ]]; then
    read -q "?Delete $target/.autoenv? " && rm -rf $target/.autoenv
    echo ""
  fi
}
