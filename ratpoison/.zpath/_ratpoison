#compdef ratpoison
#
# Description:
# Zsh completion script for the Ratpoison Window Manager.
#
# TODO:
# o add more completion of rpcommands
#
# [2005-04-05, 20.49-21.17] by Zrajm C Akfohg (GPL-2 license)
#
# TODO:
# o add completion of args to ratpoison commands (where useful)
# o better completion of --display arg
#

local state context line
typeset -A opt_args

   _arguments \
       '(- :)'{-h,--help}'[display help information]' \
       '(- :)'{-v,--version}'[display version information]' \
       '(-d --display)'{-d,--display}'[specify X display to use]:display:_x_display' \
       '(-s --screen)'{-s,--screen}'[use only specified screen]:number:' \
       '(-c --command)'{-c,--command}'[send ratpoison colon-command]:ratpoison command:->cmd' \
       '(-i --interactive)'{-i,--interactive}'[send commands in interactive mode]' \
       '(-f --file)'{-f,--file}'[specify an alternative config file]:files:_files'

   if [[ $state = cmd ]]; then
local rpcommands
       rpcommands=(
	   abort addhook alias bind banish banishrel chdir clrunmanaged cnext cprev
	   colon compat cother curframe definekey def dedicate delete delkmap describekey
	   echo escape exchangedown exchangeleft exchangeright exchangeup exec execa execf
	   fdump focus focuslast focusleft focusdown focusright focusprev focusup frestore
	   fselect gdelete getenv getsel gmerge gmove gnew gnewbg gnext gother gprev gravity grename
	   groups gselect help hsplit inext info iprev iother kill lastmsg license link listhook
	   meta msgwait newkmap newwm next nextscreen number only other prev prevscreen prompt
	   putsel quit ratinfo ratrelinfo ratwarp ratrelwarp ratclick rathold readkey redisplay redo remhook
	   remove resize restart rudeness sdump select set setenv sfrestore sfdump shrink split
	   source sselect startup_message swap time title tmpwm unalias unbind
	   undefinekey undo unmanage unsetenv verbexec version vsplit warp windows
       )
       _values "ratpoison commands" ${(q)rpcommands[@]}
fi
  #[[eof]]
