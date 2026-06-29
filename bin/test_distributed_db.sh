#!/usr/bin/env bash
# run this in a terminal: 
# bin/test_distributed_db.sh
set -e

# Always run from the project root
cd "$(dirname "$0")/.."

echo "=== Starting dedicated DB node (db@localhost) ==="
elixir --name db@127.0.0.1 -S mix run --no-halt -e "CjkDoubleStroke.DBServer.start_link([])" > /tmp/db_node.log 2>&1 &
DB_PID=$!
echo "DB node started with PID $DB_PID (logs in /tmp/db_node.log)"

# Give the DB node time to start Mnesia and load data
sleep 8

echo "=== Running verification on app node (app@localhost) ==="
elixir --name app@127.0.0.1 -S mix run -e '
  Node.connect(:"db@127.0.0.1") || raise("Failed to connect to db@127.0.0.1")
  IO.puts("Connected to DB node")

  CjkDoubleStroke.DBClient.connect()
  IO.puts("DBClient connected")

  alias CjkDoubleStroke.Idsidentifier.Idsnested

  result = Idsnested.ids_init_search("是")
  expected = ["日", "一", "龰"]

  IO.inspect(result, label: "Result")
  IO.inspect(expected, label: "Expected")

  if result == expected do
    IO.puts("SUCCESS: ids_init_search(\"是\") returned the expected result")
    System.halt(0)
  else
    IO.puts("FAILURE: unexpected result")
    System.halt(1)
  end
'

echo "=== Cleaning up DB node ==="
kill $DB_PID 2>/dev/null || true
wait $DB_PID 2>/dev/null || true
echo "Done."