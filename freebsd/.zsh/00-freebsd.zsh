
#
# ~/.zsh/00-freebsd.zsh
# ZSH settings for FreeBSD
#

export CLICOLOR=1

# freebsd ls doesn't understand --color
ls_options=()

# nor --backup, ask if override is ok instead
cp_options=( -i )
mv_options=( -i )

mktemp_options=(-t tmp)
