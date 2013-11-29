
#
# base/df-build.zsh
# clone zsh-completions
#

comp_dir=$target/.zsh-completion
help_dir=$target/.zhelp
git_url='https://github.com/zsh-users/zsh-completions'

build_base() {
  check_make_env perl

  clone_git "base" $git_url $comp_dir || return 1

  echo -n "generate helpfiles..."
  mkdir -p $help_dir
  perl base/bin/helpfiles zshall $help_dir &>>$logfile || {
    echo "failed!"
    return 1
  }

  echo "done"
}

clean_base() {
  clean_dir $comp_dir
  clean_dir $help_dir
}
