__fzf_prune="-path '*/\\.*' \
-o -fstype 'sysfs' \
-o -fstype 'devfs' \
-o -fstype 'devtmpfs' \
-o -fstype 'proc'"

# selects a file
__fzf_fsel() {
  local default="find -L . -mindepth 1 \
    \\( $__fzf_prune \\) -prune \
    -o -type f -print \
    -o -type d -print \
    -o -type l -print \
    2>/dev/null | cut -b3-"
  local cmd="${FZF_CLI_COMMAND:-"$default"}"
  eval "$cmd" | fzf --multi | sed "s/\\(.*\\)/'\\1'/" | paste -sd " " -
}

# selects a directory
__fzf_dsel() {
  local default="find -L . -mindepth 1 \
    \\( $__fzf_prune \\) -prune \
    -o -type d -print \
    2>/dev/null | cut -b3-"
  local cmd="${FZF_CD_COMMAND:-"$default"}"
  eval "$cmd" | fzf
}

alias cdf='cd $(__fzf_dsel)'
