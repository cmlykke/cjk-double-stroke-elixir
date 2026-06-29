defmodule CjkDoubleStroke.DBServer do
  @moduledoc """
  Mnesia database server. Run this on a dedicated DB node.
  Start with: iex --sname db@localhost -S mix run --no-halt -e "CjkDoubleStroke.DBServer.start_link([])"
  """

  use GenServer

  @table :cjk_data

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(_) do
    :mnesia.start()
    ensure_schema_and_table()
    {:ok, %{loaded: false}}
  end

  defp ensure_schema_and_table do
    case :mnesia.create_schema([node()]) do
      :ok -> :ok
      {:error, {_, {:already_exists, _}}} -> :ok
      error -> IO.inspect(error, label: "Schema creation")
    end

    case :mnesia.create_table(@table, [
           attributes: [:key, :value],
           type: :set,
           ram_copies: [node()],
           record_name: @table
         ]) do
      {:atomic, :ok} -> :ok
      {:aborted, {:already_exists, _}} -> :ok
      error -> IO.inspect(error, label: "Table creation")
    end

    :mnesia.wait_for_tables([@table], 5000)
  end

  # Public API (called via :rpc or GenServer on DB node)
  def put(key, value) do
    GenServer.call(__MODULE__, {:put, key, value})
  end

  def get(key) do
    GenServer.call(__MODULE__, {:get, key})
  end

  def load_static_data do
    GenServer.call(__MODULE__, :load_static_data, 300_000)
  end

  @impl true
  def handle_call({:put, key, value}, _from, state) do
    {:atomic, result} = :mnesia.transaction(fn ->
      :mnesia.write({@table, key, value})
    end)
    {:reply, result, state}
  end

  @impl true
  def handle_call({:get, key}, _from, state) do
    {:atomic, result} = :mnesia.transaction(fn ->
      case :mnesia.read({@table, key}) do
        [{@table, ^key, value}] -> value
        _ -> nil
      end
    end)
    {:reply, result, state}
  end

  @impl true
  def handle_call(:load_static_data, _from, %{loaded: true} = state) do
    {:reply, :already_loaded, state}
  end

  @impl true
  def handle_call(:load_static_data, _from, %{loaded: false} = state) do
    alias CjkDoubleStroke.Datagenerators.Readfiles.Readstaticfiles

    IO.puts("Loading static CJK data into Mnesia on DB node...")

    IO.write("  [1/7] cedict... ")
    cedict = Readstaticfiles.read_cedict()
    write(:cedict, cedict)
    IO.puts("done (#{length(cedict)} entries)")

    IO.write("  [2/7] radicals... ")
    radicals = Readstaticfiles.read_radicals_set()
    write(:radicals, radicals)
    IO.puts("done (#{MapSet.size(radicals)} radicals)")

    IO.write("  [3/7] conway strokes... ")
    conway = Readstaticfiles.read_conway_strokes()
    write(:conway, conway)
    IO.puts("done (#{length(conway)} entries)")

    IO.write("  [4/7] ids... ")
    ids = Readstaticfiles.read_ids()
    write(:ids, ids)
    IO.puts("done (#{length(ids)} entries)")

    IO.write("  [5/7] hongbing... ")
    hongbing = Readstaticfiles.read_hongbing_csv()
    write(:hongbing, hongbing)
    IO.puts("done (#{length(hongbing)} entries)")

    IO.write("  [6/7] global wordfreq... ")
    global_freq = Readstaticfiles.read_global_wordfreq()
    write(:global_wordfreq, global_freq)
    IO.puts("done (#{length(global_freq)} entries)")

    IO.write("  [7/7] tzai... ")
    tzai = Readstaticfiles.read_tzai()
    write(:tzai, tzai)
    IO.puts("done (#{length(tzai)} entries)")

    IO.write("  words.json... ")
    words = Readstaticfiles.read_words_json_stream() |> Enum.to_list()
    write(:words_json, words)
    IO.puts("done (#{length(words)} words)")

    IO.write("  Building lookup maps... ")
    write(:conway_map, Map.new(conway))
    write(:ids_map, Map.new(ids))
    write(:hongbing_map, Map.new(hongbing))
    write(:global_map, Map.new(global_freq))
    write(:tzai_map, Map.new(tzai))
    write(:words_map, Map.new(words))
    IO.puts("done")

    IO.puts("Static data loaded into Mnesia on DB node.")
    {:reply, :ok, %{state | loaded: true}}
  end

  # Internal write used by the loader (avoids GenServer.call deadlock)
  defp write(key, value) do
    {:atomic, _} = :mnesia.transaction(fn ->
      :mnesia.write({@table, key, value})
    end)
    :ok
  end
end
