if command -q dpkg
  abbr -ag apt-rc "dpkg -l | grep '^rc' | awk '{ print $2 }'"
  abbr -ag purge "sudo apt autoremove --purge (dpkg -l | grep '^rc' | awk '{ print $2 }')"
end

if command -q apt
  abbr -ag p sudo apt
  abbr -ag pi sudo apt install
  abbr -ag pd sudo apt remove
  abbr -ag pu sudo apt upgrade -U
  abbr -ag pq sudo apt search
end
