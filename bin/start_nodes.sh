#!/usr/bin/env bash
set -e

# Always run from the project root
cd "$(dirname "$0")/.."

SESSION="cjk-dev"

# Kill old session if it exists
tmux has-session -t "$SESSION" 2>/dev/null && tmux kill-session -t "$SESSION"

echo "Creating tmux session '$SESSION' with DB + App nodes..."

tmux new-session -d -s "$SESSION" -n db \
  "iex --name db@127.0.0.1 -S mix run --no-halt -e 'CjkDoubleStroke.Datagenerators.DBServer.start_link([])'"

# Force numeric window indices starting at 0 so Ctrl+b 0/1 always works
tmux set-option -t "$SESSION" base-index 0
tmux set-option -t "$SESSION" pane-base-index 0

# Wait a bit for the DB node to start
sleep 3

tmux new-window -t "$SESSION" -n app \
  "iex --name app@127.0.0.1 -S mix"

# Send connect command to the app window after it starts
sleep 2
tmux send-keys -t "$SESSION:app" 'CjkDoubleStroke.Datagenerators.DBClient.connect()' C-m
tmux send-keys -t "$SESSION:app" 'IO.puts("Connected to DB node")' C-m

echo ""
echo "Tmux session '$SESSION' created."
echo "Attach with: tmux attach -t $SESSION"
echo "Switch windows with: Ctrl+b then 0 (db) or 1 (app)"
echo "Detach with: Ctrl+b then d"
echo ""
echo "To stop everything later, run: ./bin/stop_nodes.sh"



