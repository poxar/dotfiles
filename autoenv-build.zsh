
#
# autoenv/df-build.zsh
# clone latest autoenv
#

bin_dir="$target/.autoenv"
git_url='https://github.com/sharat87/autoenv'

build_autoenv() {
  check_env make
  clone_git "autoenv" "$git_url" "$bin_dir"
  echo "done"
}

clean_autoenv() {
  clean_dir "$bin_dir"
}
