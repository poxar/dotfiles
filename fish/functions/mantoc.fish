function mantoc --wraps man
  zcat (command man -w $argv) | grep -i '^.sh' | cut -d' ' -f2-
end
