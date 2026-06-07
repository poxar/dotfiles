function todo --description="Search for TODO markers in the current directory"
  if command -q rg
    rg 'TODO|FIXME|XXX' $argv
  else
    grep -R 'TODO\|FIXME\|XXX' $argv
  end
end
