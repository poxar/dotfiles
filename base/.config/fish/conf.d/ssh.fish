# Wrap scp(1) to check for missing colons
function scp --wraps scp
  if test (count $argv) -ge 2
    switch "$argv"
      case '*:*'
      case '*'
	printf >&2 'scp(): Missing colon, probably an error\n'
	return 2
    end
  end

  command scp $argv
end
