# Wrap scp(1) to check for missing colons
scp() {
  if [ "$#" -ge 2 ] ; then
    case $* in
      *:*) ;;
      *)
        printf >&2 'scp(): Missing colon, probably an error\n'
        return 2
        ;;
    esac
  fi
  command scp "$@"
}
