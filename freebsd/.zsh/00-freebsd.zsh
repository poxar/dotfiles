
#
# ~/.zsh/00-freebsd.zsh
# ZSH settings for FreeBSD
#

# freebsd ls doesn't understand --color
ls_options=()
export CLICOLOR=1
ll() { CLICOLOR_FORCE=1 ls -lAh "$@" | less -r }

# nor --backup, ask if override is ok instead
cp_options=( -i )
mv_options=( -i )

mktemp_options=(-t tmp)
