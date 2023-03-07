if command -q sqlite3
  set -xg SQLITE_HISTORY "$XDG_STATE_HOME/sqlite_history"
  alias sqlite3 'sqlite3 -init "$XDG_CONFIG_HOME/sqliterc"'
end
