# basic zsh config

#### OPTIONS
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
unsetopt nomatch            # pass unmatched globs to the argument list

#### MODULES
autoload -U colors && colors # be colorful
autoload -U zfinit && zfinit # zftp
autoload -U zmv              # renaming tool
autoload -U zcalc            # calculator

#### HISTORY
HISTFILE="$ZCONFDIR/history"
HISTSIZE=20000
SAVEHIST=20000
HISTIGNORE="exit"

setopt hist_ignore_all_dups    # delete old duplicates
setopt hist_ignore_space       # ignore commands starting with space for history
setopt hist_lex_words          # parse history files correctly
setopt inc_append_history_time # append to the histfile directly (with correct times)
setopt extended_history        # use the extended history format
setopt hist_fcntl_lock         # use modern locking

unsetopt share_history         # don't load history automatically

# History can now be shared manually (one-time) with `fc -RI`

#### DIRS
hash -d doc=/usr/share/doc
hash -d log=/var/log

#### PROMPT
# change the prompt on mode-switch
function zle-line-init zle-keymap-select {
  set-prompt $KEYMAP
  zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

# set the prompt now
autoload -Uz set-prompt
set-prompt
