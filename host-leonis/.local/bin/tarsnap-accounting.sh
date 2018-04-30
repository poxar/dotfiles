#!/bin/bash
set -euo pipefail

file=${1:-"accounting.csv"}

consumed="$(awk '
BEGIN {
  FS = ","
}
$1 == "Usage" {
  u[$2] += $6

  if ($4 == "Daily storage")
    s[$2] += $6
}
END {
  print "DATE","TOTAL","STORAGE"
  for (i in u) print i,u[i],s[i];
}
' "$file")"

days=$(echo "$consumed" | sort -n)
avgs=$(echo "$consumed" | awk '
{
  u+=$2
  s+=$3
}
END {
print "AVG",( u / NR),( s / NR)
print "MONTH",( u / NR) * 30,( s / NR) * 30
}')

echo "$days
$avgs" | column -t
