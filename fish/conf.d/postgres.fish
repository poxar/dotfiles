if command -q psql
  set -xg PSQLRC "$XDG_CONFIG_HOME/psqlrc"
  mkdir -p "$XDG_STATE_HOME/psql/history"
end
