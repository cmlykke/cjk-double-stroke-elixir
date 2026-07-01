
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
      ids_init_wholechar(input)
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

  def ids_init_wholechar(""), do: []

  def ids_init_wholechar(char) when is_binary(char) do
    #IO.puts("ids_init_wholechar: processing #{inspect(char)}")
    lookup = StaticData.get_ids(char)
    #IO.inspect(lookup, label: "StaticData.get_ids returned")

    cond do
      is_nil(lookup) or lookup == char ->
        #IO.puts("→ returning [char]")
        [char]

      is_binary(lookup) ->
        cleaned = Utils.remove_shape_chars(lookup)
        removeascii = Utils.remove_printable_ascii(cleaned)
        graphemes = Utils.safe_to_graphemes(removeascii)

        # Split the grapheme list over whitespace
        segments = Utils.split_on_whitespace(graphemes)
        # unwrap single nested lists if necessary
        unwrap = Utils.unwrap_single_nested(segments)

        # For each segment, call ids_init_charlist and collect results
        # This creates a nested list: [[result1], [result2], ...]
        result = Enum.map(unwrap, fn x ->
          wrapped_segment = List.wrap(x)
          ids_init_charlist(wrapped_segment)
        end)

        preres = Utils.unwrap_singletons(result)
        preres

      true ->
        IO.warn("Unexpected lookup: #{inspect(lookup)}")
        [char]
    end
  end


  def ids_init_wholechar(other) do
    IO.warn("ids_init_wholechar unexpected: #{inspect(other)}")
    [to_string(other)]
  end


  def ids_init_charlist([]), do: []

  def ids_init_charlist(list) when is_list(list) do
    #IO.inspect(list, label: "ids_init_charlist input list")
    Enum.flat_map(list, fn item ->
      case item do
        head when is_binary(head) ->
          #IO.puts("  → recursing on binary: #{inspect(head)}")
          ids_init_wholechar(head)
        other ->
          #IO.warn("  → bad item: #{inspect(other)}")
          ids_init_wholechar(to_string(other))
      end
    end)
  end

  def ids_init_charlist(bad_arg) do
    IO.inspect(bad_arg, label: "CRITICAL BAD ARG to ids_init_charlist")
    []
  end
end
