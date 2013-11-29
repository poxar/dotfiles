
#
# ratpoison/df-build.zsh
# clone zsh-completions-ratpoison
#

comp_dir=$target/.zsh-completion-ratpoison
git_url='https://github.com/ivoarch/zsh-completion-ratpoison'

build_ratpoison() {
  clone_git "ratpoison" $git_url $comp_dir || return 1
  echo "done"
}

clean_ratpoison() {
  clean_dir $comp_dir
}
