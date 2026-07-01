
defmodule CjkDoubleStroke.Idsidentifier.Idsnested do
  @moduledoc """
  Handles nested IDS (Ideographic Description Sequences) for CJK characters.
  Uses StaticData as the data source.
  """

  alias CjkDoubleStroke.Datagenerators.StaticData
  alias CjkDoubleStroke.Utils

  @spec ids_init_search(binary()) :: [binary()]
  def ids_init_search(input) when is_binary(input) do
    #IO.puts("=== ids_init_search called with: #{inspect(input)} ===")
    try do
      initwithremain = {[], input, []}
      res = ids_init_wholechar(initwithremain)
      res
    rescue
      e in FunctionClauseError ->
        IO.warn("FunctionClauseError in ids_init_search(#{inspect(input)}): #{Exception.message(e)}")
        IO.warn("Stacktrace: #{inspect(__STACKTRACE__)}")
        [input]
      e ->
        IO.warn("Unexpected error: #{Exception.message(e)}")
        [input]
    end
  end

  def ids_init_search(other) do
    IO.warn("ids_init_search non-binary: #{inspect(other)}")
    [to_string(other)]
  end



  def ids_init_wholechar({[], "", []}), do: {[],"",[]}


  def ids_init_wholechar({begin, char, remain}) when is_binary(char) do
    #IO.puts("ids_init_wholechar: processing #{inspect(char)}")
    lookup = StaticData.get_ids(char)
    #IO.inspect(lookup, label: "StaticData.get_ids returned")
    cond do
      is_nil(char) ->
        begin

      remain == [] and is_nil(lookup) ->
        begin ++ [char]

      remain == [] and lookup == char ->
        begin ++ [char]

      is_nil(lookup) or lookup == char ->
        [head | tail] = remain
        recurobj = {begin ++ [char], head, tail}
        ids_init_wholechar(recurobj)

      is_binary(lookup) ->
        cleaned = Utils.remove_shape_chars(lookup)
        removeascii = Utils.remove_printable_ascii(cleaned)
        graphemes = Utils.safe_to_graphemes(removeascii)
        segments = Utils.split_on_whitespace(graphemes)
        result = Enum.map(segments, fn x ->
          wrapped_segment = List.wrap(x)
          [head | tail] = wrapped_segment
          newtupple = {begin, head, tail ++ remain}
          ids_init_wholechar(newtupple)
        end)

        preres = Utils.unwrap_nested(result)
        preres

      true ->
        IO.warn("Unexpected lookup: #{inspect(lookup)}")
        {[char], remain}
    end
  end


  def ids_init_wholechar(other) do
    IO.warn("ids_init_wholechar unexpected: #{inspect(other)}")
    other
  end


end
