
defmodule CjkDoubleStroke.Idsidentifier.Idsnested do
  @moduledoc """
  Handles nested IDS (Ideographic Description Sequences) for CJK characters.
  Uses StaticData as the data source.
  """

  alias CjkDoubleStroke.Idsidentifier.Strokerollout
  alias CjkDoubleStroke.Datagenerators.StaticData
  alias CjkDoubleStroke.Utils

  @spec char_init_ids_matches(binary(), any()) :: binary()
  @spec char_init_ids_matches(binary(), any()) :: list()
  def char_init_ids_matches(char, idselems) when is_binary(char) do
    rawstatic = StaticData.get_conway(char)
    charconway = Strokerollout.stroke_rollout(char)

    charrollout = ids_init_search(char)#Strokerollout.stroke_rollout(char)
    charjoins = Enum.map(charrollout, fn x -> Enum.join(x) end)
    #findrollout = Enum.filter(charjoins, fn charrollversion ->
    #    Enum.filter(idselems, &String.starts_with?(charrollversion, &1))
    #  end)

    findrolloutTWO = Enum.filter(idselems, fn prefix ->
        Enum.any?(charjoins, &String.starts_with?(&1, prefix))
      end)
    #create alle the rollouts for the found elems
    foundelemrolls = Enum.map(findrolloutTWO, fn foundelem ->
        Strokerollout.stroke_rollout_multistr(foundelem)
      end)
    identical = Utils.allitendical(foundelemrolls)
    if not identical do
      raise ConwayError,
        message: """
        Conway coded for found elems
        are not identical: #{inspect(char)}

        Found #{length(foundelemrolls)} available characters:
        #{inspect(foundelemrolls, pretty: true)}
        """
    end

    # create code to match the rollout elems with rollout conway
    flattenelemrollouts = Enum.map(foundelemrolls, fn eachlist -> Enum.join(eachlist, "")end)
    strokematches = Strokerollout.matchinitstrokeswithmain(charconway, flattenelemrollouts)
    #commonstrings = Strokerollout.common_strings()
    {char, strokematches, findrolloutTWO, flattenelemrollouts, rawstatic}
  end


  @spec ids_init_search(binary()) :: [binary()]
  def ids_init_search(input) when is_binary(input) do
    #IO.puts("=== ids_init_search called with: #{inspect(input)} ===")
    try do
      initwithremain = {[], input, []}
      res = ids_init_wholechar(initwithremain)
      Enum.uniq(res)
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


  @spec ids_head_ids(any()) :: binary() | [binary(), ...] | {[], <<>>, []}
  def ids_head_ids(input) when is_binary(input) do
    #IO.puts("=== ids_init_search called with: #{inspect(input)} ===")
    try do
      initwithremain = {[], input, []}
      res = ids_head_findhead(initwithremain)
      Enum.uniq(res)
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

  def ids_head_ids(other) do
    IO.warn("ids_head_ids non-binary: #{inspect(other)}")
    [to_string(other)]
  end

  defp ids_head_findhead({[], "", []}), do: {[],"",[]}

  defp ids_head_findhead({begin, char, remain}) when is_binary(char) do
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
        ids_head_findhead(recurobj)

      is_binary(lookup) ->
        cleaned = Utils.remove_shape_chars(lookup)
        removeascii = Utils.remove_printable_ascii(cleaned)
        graphemes = Utils.safe_to_graphemes(removeascii)
        segments = Utils.split_on_whitespace(graphemes)
        result = Enum.map(segments, fn x ->
          wrapped_segment = List.wrap(x)
          [head | _] = wrapped_segment
          newtupple = {begin ++ [char], head, remain}
          ids_head_findhead(newtupple)
        end)

        preres = Utils.unwrap_nested(result)
        preres

      true ->
        IO.warn("Unexpected lookup: #{inspect(lookup)}")
        {[char], remain}
    end
  end

  defp ids_head_findhead(other) do
    IO.warn("ids_head_findhead unexpected: #{inspect(other)}")
    other
  end

  defp ids_init_wholechar({[], "", []}), do: {[],"",[]}

  defp ids_init_wholechar({begin, char, remain}) when is_binary(char) do
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


  defp ids_init_wholechar(other) do
    IO.warn("ids_init_wholechar unexpected: #{inspect(other)}")
    other
  end


end
