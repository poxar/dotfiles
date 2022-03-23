if command -q tmux
  abbr -ag tn tmux new-session
  abbr -ag ta tmux new-session -A
  abbr -ag td tmux new-session -As default
  abbr -ag tp tmuxp load -y .tmuxp.yaml
end
