function dots --description="Manage dotfiles" --wraps="git --git-dir=$XDG_DATA_HOME/dots" -a command
  set -l dots_dir $XDG_DATA_HOME/dots

  if not test -d $dots_dir
    echo "Not managed with dots"
    return 1
  end

  set -l git_args
  if test -z "$command"
    set git_args status
  else if test "$command" = "all"
    set git_args status -unormal $argv[2..-1]
  else
    set git_args $argv
  end

  set -x GIT_WORK_TREE $XDG_CONFIG_HOME
  set -x GIT_DIR $dots_dir

  git config --local status.showUntrackedFiles no
  git config --local core.worktree $XDG_CONFIG_HOME
  git config --local core.bare false
  git config --local core.logallrefupdates true
  git config --local core.excludesFile $XDG_CONFIG_HOME/dots/ignore

  git $git_args
end
