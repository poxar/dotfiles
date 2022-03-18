function cdtmp --description="cd into a temporary directory"
  cd (mktemp -d /tmp/tmp.XXXXXX); or return 1
  pwd
end
