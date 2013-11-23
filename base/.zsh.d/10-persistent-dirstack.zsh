
DIRSTACKSIZE=9
DIRSTACKFILE=$HOME/.zdirs

if [[ -f $DIRSTACKFILE ]] && [[ $#dirstack -eq 0 ]]; then
  dirstack=( ${(f)"$(< $DIRSTACKFILE)"} )
  [[ -d $dirstack[1] ]] && cd $dirstack[1] && cd $OLDPWD
fi

chpwd() {
  print -l $PWD ${(u)dirstack} >$DIRSTACKFILE
}
