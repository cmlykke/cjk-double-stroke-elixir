defmodule CjkDoubleStroke.Datagenerators.StaticData do
  @moduledoc """
  Fast in-memory store for all static CJK data using :persistent_term.

  Call `init/0` once (e.g. in test_helper.exs or Application.start/2).
  After that, access is extremely fast.
  """

  # No longer used locally (delegated to DB node)

  defp ensure_db_node! do
    # Try hard to connect — especially important for fresh mix test nodes
    unless CjkDoubleStroke.Datagenerators.DBClient.connected?() do
      CjkDoubleStroke.Datagenerators.DBClient.connect()
    end

    unless CjkDoubleStroke.Datagenerators.DBClient.connected?() do
      raise """
      Dedicated DB node (db@localhost) is not connected.

      Start it once in another terminal:
        iex --sname db@localhost -S mix run --no-halt -e "CjkDoubleStroke.Datagenerators.DBServer.start_link([])"

      Then connect from this node:
        CjkDoubleStroke.Datagenerators.DBClient.connect()
      """
    end
  end

  @doc """
  Ensures the remote DB node is connected.
  No local data loading happens on the app node anymore.
  """
  def init do
    ensure_db_node!()

    # Only ask the DB node to load once per app node session
    if Process.get({__MODULE__, :db_loaded}) != true do
      CjkDoubleStroke.Datagenerators.DBClient.load_static_data()
      Process.put({__MODULE__, :db_loaded}, true)
    end

    :ok
  end

  defp ensure_loaded, do: init()

  # === Accessors - all delegate to the dedicated DB node ===

  def cedict,           do: (ensure_loaded(); CjkDoubleStroke.Datagenerators.DBClient.cedict())
  def radicals_set,     do: (ensure_loaded(); CjkDoubleStroke.Datagenerators.DBClient.radicals_set())
  def conway_strokes,   do: (ensure_loaded(); CjkDoubleStroke.Datagenerators.DBClient.conway_strokes())
  def ids,              do: (ensure_loaded(); CjkDoubleStroke.Datagenerators.DBClient.ids())
  def hongbing_csv,     do: (ensure_loaded(); CjkDoubleStroke.Datagenerators.DBClient.hongbing_csv())
  def global_wordfreq,  do: (ensure_loaded(); CjkDoubleStroke.Datagenerators.DBClient.global_wordfreq())
  def tzai,             do: (ensure_loaded(); CjkDoubleStroke.Datagenerators.DBClient.tzai())
  def words_json,       do: (ensure_loaded(); CjkDoubleStroke.Datagenerators.DBClient.words_json())
  def letter_map,       do: (ensure_loaded(); CjkDoubleStroke.Datagenerators.DBClient.letter_map())
  def aelements,        do: (ensure_loaded(); CjkDoubleStroke.Datagenerators.DBClient.aelements())
  def aelement_map,     do: (ensure_loaded(); CjkDoubleStroke.Datagenerators.DBClient.aelement_map())
  def aelement_keys,    do: (ensure_loaded(); CjkDoubleStroke.Datagenerators.DBClient.aelement_keys())

  # === Fast O(1) getters - delegated to remote DB node ===

  def get_conway(char),      do: (ensure_loaded(); CjkDoubleStroke.Datagenerators.DBClient.get_conway(char))
  def get_ids(char),         do: (ensure_loaded(); CjkDoubleStroke.Datagenerators.DBClient.get_ids(char))
  def get_hongbing(char),    do: (ensure_loaded(); CjkDoubleStroke.Datagenerators.DBClient.get_hongbing(char))
  def get_global_freq(char), do: (ensure_loaded(); CjkDoubleStroke.Datagenerators.DBClient.get_global_freq(char))
  def get_tzai(char),        do: (ensure_loaded(); CjkDoubleStroke.Datagenerators.DBClient.get_tzai(char))
  def get_word_freq(word),   do: (ensure_loaded(); CjkDoubleStroke.Datagenerators.DBClient.get_word_freq(word))

  def get_letter(code),        do: (ensure_loaded(); CjkDoubleStroke.Datagenerators.DBClient.get_letter(code))

  def get_aelement_conway(variant), do: (ensure_loaded(); CjkDoubleStroke.Datagenerators.DBClient.get_aelement_conway(variant))

  def has_radical?(r), do: (ensure_loaded(); CjkDoubleStroke.Datagenerators.DBClient.has_radical?(r))
end
