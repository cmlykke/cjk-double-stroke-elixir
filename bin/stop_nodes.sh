#!/usr/bin/env bash

# Always run from the project root
cd "$(dirname "$0")/.."

echo "=== Stopping tmux session and nodes ==="

tmux kill-session -t cjk-dev 2>/dev/null || true

pkill -f "db@127.0.0.1" 2>/dev/null || true
pkill -f "app@127.0.0.1" 2>/dev/null || true
pkill -f "cjk_double_stroke" 2>/dev/null || true

epmd -kill 2>/dev/null || true
epmd -daemon 2>/dev/null || true

rm -f /tmp/db_node.pid /tmp/db_node.log 2>/dev/null || true

echo "All nodes and tmux session stopped."
