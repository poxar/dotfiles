

#
# ~/.zsh/10-shelloptions.zsh
#

setopt auto_cd              # change directories easily
setopt no_beep              # don't beep at me!
setopt complete_in_word     # complete in words
setopt correct              # correct me
setopt auto_pushd           # always use the directory stack
setopt pushd_ignore_dups    # but never duplicate entries
setopt extended_glob        # enable heavy globbing
setopt longlistjobs         # display PID when suspending processes
setopt braceccl             # use advanced brace expansion like {a-b}
setopt nohup                # don't send SIGHUP when shell terminates
setopt transient_rprompt    # remove rprompt when command is issued
setopt functionargzero      # set $0 to be the function call
setopt local_options        # allow functions to have local options
setopt prompt_subst         # fully update prompts
setopt interactive_comments # allow comments in interactive shells
setopt rm_starsilent        # i know what i'm doing (most of the time)

unsetopt flowcontrol        # deactivate "freezing"
