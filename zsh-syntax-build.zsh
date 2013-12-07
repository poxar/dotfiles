

#
# zsh-syntax-build.zsh
# clone zsh-syntax-highlighting
#

high_dir=$target/.zsh-syntax
git_url='https://github.com/zsh-users/zsh-syntax-highlighting'

build_zsh-syntax() {
  clone_git "base" $git_url $high_dir || return 1
  echo "done"
}

clean_zsh-syntax() {
  clean_dir $high_dir
}
