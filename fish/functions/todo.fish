function todo --description="Search for TODO markers in the current directory"
  if command -q rg
    rg 'TODO|HACK|FIXME|OPTIMIZE' $argv
  else
    grep -R 'TODO\|HACK\|FIXME\|OPTIMIZE' $argv
  end
end
