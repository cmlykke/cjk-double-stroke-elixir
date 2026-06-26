defmodule CjkDoubleStroke.Datagenerators.StaticData do
  @moduledoc """
  Fast in-memory store for all static CJK data using :persistent_term.

  Call `init/0` once (e.g. in test_helper.exs or Application.start/2).
  After that, access is extremely fast.
  """

  alias CjkDoubleStroke.Datagenerators.Readfiles.Readstaticfiles

  # Persistent term keys (using tuples to avoid collisions)
  @cedict          {__MODULE__, :cedict}
  @radicals        {__MODULE__, :radicals}
  @conway          {__MODULE__, :conway_strokes}
  @ids             {__MODULE__, :ids}
  @hongbing        {__MODULE__, :hongbing}
  @global_wordfreq {__MODULE__, :global_wordfreq}
  @tzai            {__MODULE__, :tzai}
  @words_json      {__MODULE__, :words_json}

  # Map keys for O(1) lookups
  @conway_map      {__MODULE__, :conway_map}
  @ids_map         {__MODULE__, :ids_map}
  @hongbing_map    {__MODULE__, :hongbing_map}
  @global_map      {__MODULE__, :global_map}
  @tzai_map        {__MODULE__, :tzai_map}
  @words_map       {__MODULE__, :words_map}

  @doc """
  Load all data into memory. Safe to call multiple times.
  """
  def init do
    # Only load if not already loaded
    if :persistent_term.get(@global_wordfreq, :not_loaded) == :not_loaded do
      :persistent_term.put(@cedict,          Readstaticfiles.read_cedict())
      :persistent_term.put(@radicals,        Readstaticfiles.read_radicals_set())
      :persistent_term.put(@conway,          Readstaticfiles.read_conway_strokes())
      :persistent_term.put(@ids,             Readstaticfiles.read_ids())
      :persistent_term.put(@hongbing,        Readstaticfiles.read_hongbing_csv())
      :persistent_term.put(@global_wordfreq, Readstaticfiles.read_global_wordfreq())
      :persistent_term.put(@tzai,            Readstaticfiles.read_tzai())

      words = Readstaticfiles.read_words_json_stream() |> Enum.to_list()
      :persistent_term.put(@words_json, words)

      # Build lookup maps
      :persistent_term.put(@conway_map,   Map.new(:persistent_term.get(@conway)))
      :persistent_term.put(@ids_map,      Map.new(:persistent_term.get(@ids)))
      :persistent_term.put(@hongbing_map, Map.new(:persistent_term.get(@hongbing)))
      :persistent_term.put(@global_map,   Map.new(:persistent_term.get(@global_wordfreq)))
      :persistent_term.put(@tzai_map,     Map.new(:persistent_term.get(@tzai)))
      :persistent_term.put(@words_map,    Map.new(words))

      :ok
    else
      :already_loaded
    end
  end

  # === Accessors (return the same structure as before) ===

  def cedict,           do: :persistent_term.get(@cedict)
  def radicals_set,     do: :persistent_term.get(@radicals)
  def conway_strokes,   do: :persistent_term.get(@conway)
  def ids,              do: :persistent_term.get(@ids)
  def hongbing_csv,     do: :persistent_term.get(@hongbing)
  def global_wordfreq,  do: :persistent_term.get(@global_wordfreq)
  def tzai,             do: :persistent_term.get(@tzai)
  def words_json,       do: :persistent_term.get(@words_json)

  # === Fast O(1) getters ===

  def get_conway(char),      do: Map.get(:persistent_term.get(@conway_map), char)
  def get_ids(char),         do: Map.get(:persistent_term.get(@ids_map), char)
  def get_hongbing(char),    do: Map.get(:persistent_term.get(@hongbing_map), char)
  def get_global_freq(char), do: Map.get(:persistent_term.get(@global_map), char)
  def get_tzai(char),        do: Map.get(:persistent_term.get(@tzai_map), char)
  def get_word_freq(word),   do: Map.get(:persistent_term.get(@words_map), word)

  def has_radical?(r), do: MapSet.member?(radicals_set(), r)
end
