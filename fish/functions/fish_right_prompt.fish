function fish_right_prompt
  set -gx __fish_git_prompt_showstashstate true
  set -gx __fish_git_prompt_use_informative_chars true

  echo -n (fish_vcs_prompt " ")
end
