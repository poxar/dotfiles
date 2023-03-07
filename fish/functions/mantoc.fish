function mantoc --wraps man
  zcat (man -w $argv) | grep -i '^.sh' | cut -d' ' -f2-
end
