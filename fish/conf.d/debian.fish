if command -q dpkg
  abbr -ag apt-rc "dpkg -l | grep '^rc' | awk '{ print $2 }'"
  abbr -ag purge "sudo apt autoremove --purge (dpkg -l | grep '^rc' | awk '{ print $2 }')"
end
