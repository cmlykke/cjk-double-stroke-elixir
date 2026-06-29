defmodule CjkDoubleStroke.DBClient do
  @moduledoc """
  Client API for the remote Mnesia DB node.
  Configure the DB node name via config or env.
  """

  @db_node Application.compile_env(:cjk_double_stroke, :db_node, :"db@127.0.0.1")

  def put(key, value) do
    GenServer.call({CjkDoubleStroke.DBServer, @db_node}, {:put, key, value})
  end

  def get(key) do
    GenServer.call({CjkDoubleStroke.DBServer, @db_node}, {:get, key})
  end

  def load_static_data do
    GenServer.call({CjkDoubleStroke.DBServer, @db_node}, :load_static_data, 300_000)
  end

  # Dataset accessors (read from remote DB node)
  def cedict,           do: get(:cedict)
  def radicals_set,     do: get(:radicals)
  def conway_strokes,   do: get(:conway)
  def ids,              do: get(:ids)
  def hongbing_csv,     do: get(:hongbing)
  def global_wordfreq,  do: get(:global_wordfreq)
  def tzai,             do: get(:tzai)
  def words_json,       do: get(:words_json)

  def get_conway(char),      do: Map.get(get(:conway_map), char)
  def get_ids(char),         do: Map.get(get(:ids_map), char)
  def get_hongbing(char),    do: Map.get(get(:hongbing_map), char)
  def get_global_freq(char), do: Map.get(get(:global_map), char)
  def get_tzai(char),        do: Map.get(get(:tzai_map), char)
  def get_word_freq(word),   do: Map.get(get(:words_map), word)

  def has_radical?(r), do: MapSet.member?(radicals_set(), r)

  def connect do
    # Ensure this node is part of a distributed Erlang cluster
    unless Node.alive?() do
      {:ok, _} = :net_kernel.start([:"test-#{:rand.uniform(9999)}@127.0.0.1"])
    end

    # Retry connection to the dedicated DB node
    Enum.any?(1..15, fn i ->
      Process.sleep(i * 20)
      case Node.connect(@db_node) do
        true -> @db_node in Node.list()
        _    -> false
      end
    end)
  end

  def connected? do
    @db_node in Node.list()
  end
end
