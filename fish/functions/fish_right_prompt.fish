function fish_right_prompt
  if test "$TRANSIENT" != 1
    # working directory
    # replace $HOME with ~
    set -l my_pwd (string replace -r '^'$HOME'($|/)' '~$1' $PWD)
    # reduce to the last two path components
    set -l pwd_paths (string split -r / $my_pwd)
    set my_pwd (string join '/' $pwd_paths[-2-1])
    # add the result to the prompt
    echo -n -s (set_color brblue) "$my_pwd" (set_color normal)

    # vcs info if in repository
    set -x __fish_git_prompt_showcolorhints 1
    set -x __fish_git_prompt_color_branch --bold bryellow
    set -x __fish_git_prompt_color_branch_detached --bold brred
    set -x __fish_git_prompt_show_informative_status 1
    set -x __fish_git_prompt_char_stateseparator ' '
    set -x __fish_git_prompt_showstashstate 1
    set -x __fish_git_prompt_showupstream auto
    set -x fish_prompt_hg_show_informative_status 1
    fish_vcs_prompt ' on %s'

    # finally add some padding to the right
    echo -sn " "
  end
end
