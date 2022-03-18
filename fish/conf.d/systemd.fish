if command -q systemctl
  abbr -ag s sudo systemctl
  abbr -ag sr sudo systemctl restart
  abbr -ag st systemctl status

  abbr -ag suu systemctl --user
  abbr -ag sur systemctl --user restart
  abbr -ag sus systemctl --user status
end
