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
    if :persistent_term.get(@global_wordfreq, :not_loaded) == :not_loaded do
      IO.puts("Loading static CJK data into memory (this may take a while for large files)...")

      IO.write("  [1/7] cedict... ")
      cedict = Readstaticfiles.read_cedict()
      :persistent_term.put(@cedict, cedict)
      IO.puts("done (#{length(cedict)} entries)")

      IO.write("  [2/7] radicals... ")
      radicals = Readstaticfiles.read_radicals_set()
      :persistent_term.put(@radicals, radicals)
      IO.puts("done (#{MapSet.size(radicals)} radicals)")

      IO.write("  [3/7] conway strokes... ")
      conway = Readstaticfiles.read_conway_strokes()
      :persistent_term.put(@conway, conway)
      IO.puts("done (#{length(conway)} entries)")

      IO.write("  [4/7] ids... ")
      ids = Readstaticfiles.read_ids()
      :persistent_term.put(@ids, ids)
      IO.puts("done (#{length(ids)} entries)")

      IO.write("  [5/7] hongbing... ")
      hongbing = Readstaticfiles.read_hongbing_csv()
      :persistent_term.put(@hongbing, hongbing)
      IO.puts("done (#{length(hongbing)} entries)")

      IO.write("  [6/7] global wordfreq... ")
      global_freq = Readstaticfiles.read_global_wordfreq()
      :persistent_term.put(@global_wordfreq, global_freq)
      IO.puts("done (#{length(global_freq)} entries)")

      IO.write("  [7/7] tzai... ")
      tzai = Readstaticfiles.read_tzai()
      :persistent_term.put(@tzai, tzai)
      IO.puts("done (#{length(tzai)} entries)")

      IO.write("  words.json (streaming + unique)... ")
      words = Readstaticfiles.read_words_json_stream() |> Enum.to_list()
      :persistent_term.put(@words_json, words)
      IO.puts("done (#{length(words)} words)")

      IO.write("  Building fast lookup maps... ")
      :persistent_term.put(@conway_map,   Map.new(conway))
      :persistent_term.put(@ids_map,      Map.new(ids))
      :persistent_term.put(@hongbing_map, Map.new(hongbing))
      :persistent_term.put(@global_map,   Map.new(global_freq))
      :persistent_term.put(@tzai_map,     Map.new(tzai))
      :persistent_term.put(@words_map,    Map.new(words))
      IO.puts("done")

      IO.puts("StaticData ready.")
      :ok
    else
      :already_loaded
    end
  end

  defp ensure_loaded, do: init()

  # === Accessors (return the same structure as before) ===

  def cedict,           do: (ensure_loaded(); :persistent_term.get(@cedict))
  def radicals_set,     do: (ensure_loaded(); :persistent_term.get(@radicals))
  def conway_strokes,   do: (ensure_loaded(); :persistent_term.get(@conway))
  def ids,              do: (ensure_loaded(); :persistent_term.get(@ids))
  def hongbing_csv,     do: (ensure_loaded(); :persistent_term.get(@hongbing))
  def global_wordfreq,  do: (ensure_loaded(); :persistent_term.get(@global_wordfreq))
  def tzai,             do: (ensure_loaded(); :persistent_term.get(@tzai))
  def words_json,       do: (ensure_loaded(); :persistent_term.get(@words_json))

  # === Fast O(1) getters ===

  def get_conway(char),      do: (ensure_loaded(); Map.get(:persistent_term.get(@conway_map), char))
  def get_ids(char),         do: (ensure_loaded(); Map.get(:persistent_term.get(@ids_map), char))
  def get_hongbing(char),    do: (ensure_loaded(); Map.get(:persistent_term.get(@hongbing_map), char))
  def get_global_freq(char), do: (ensure_loaded(); Map.get(:persistent_term.get(@global_map), char))
  def get_tzai(char),        do: (ensure_loaded(); Map.get(:persistent_term.get(@tzai_map), char))
  def get_word_freq(word),   do: (ensure_loaded(); Map.get(:persistent_term.get(@words_map), word))

  def has_radical?(r), do: (ensure_loaded(); MapSet.member?(radicals_set(), r))
end
