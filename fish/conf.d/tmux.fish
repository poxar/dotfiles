if command -q tmux
  abbr -ag tn tmux new-session -A
  abbr -ag tp tmuxp load -y .tmuxp.yaml
end
