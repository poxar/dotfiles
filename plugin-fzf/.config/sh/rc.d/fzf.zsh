__fzf_widget() {
  local args
  args=$(__fzf_fsel)

  test -n "$args" && LBUFFER+="$args"
  zle redisplay
}

zle -N __fzf_widget
bindkey -M emacs '^[ ' __fzf_widget
bindkey -M vicmd ' ' __fzf_widget

__fzf_cd_widget() {
  local dir
  dir=$(__fzf_dsel)

  test -n "$dir" && {
    zle .push-input
    LBUFFER="cd $dir"
    zle accept-line
  }
  zle redisplay
}

zle -N __fzf_cd_widget
bindkey -M emacs '^[\' __fzf_cd_widget
bindkey -M vicmd '\' __fzf_cd_widget
