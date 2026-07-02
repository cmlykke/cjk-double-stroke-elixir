

defmodule CjkDoubleStroke.Idsidentifier.Strokerollout do
  @moduledoc """
  Handles nested IDS (Ideographic Description Sequences) for CJK characters.
  Uses StaticData as the data source.
  """

  alias CjkDoubleStroke.Datagenerators.StaticData
  alias CjkDoubleStroke.Utils

  def stroke_rollout(char) when is_binary(char) do
    code = StaticData.get_conway(char)
    split = conway_split_basic(code)
    split
  end

  def split_escape(str) when is_binary(str) do
    Regex.scan(~r/(\\.|[^\\]+)/, str)
    |> Enum.map(fn [full, _] -> full end)
  end


  defp conway_split_basic(conwaystr) do
    splitonparen = String.split(conwaystr, ~r/[()]/)
    mapofsplits = extract_map_splits(splitonparen)
    mapofsplitslocal = extract_map_splits_local(splitonparen)
    # now use the map to replace the splits with the maps
    replacedStr = Enum.map(splitonparen, fn str ->
        getfrommap = Map.get(mapofsplitslocal, str)
        if getfrommap do
          getfrommap
        else
          str
        end
      end)
    # need to replace backslash
    backslashreplaced = Enum.map(replacedStr, fn each ->
      split_escape(each)
      end)#split_escape(Enum.join(replacedStr, ""))
    flatten = Utils.unwrap_single_nested(backslashreplaced)
    finalflatten = List.flatten(flatten)
    res = expand_splittet(finalflatten, mapofsplits)
    res
  end

  defp extract_map_splits(lsitofsplits) do
    pipestrings = Enum.filter(lsitofsplits, fn str ->
        is_binary(str) and String.contains?(str, "|")
      end)
    unique = Enum.uniq(pipestrings)
    indexed_map =
        unique
        |> Enum.with_index()
        |> Map.new(fn {string, index} ->
          key = "\\#{index + 1}" # "\1", "\2", "\3"...
          {key, string}
        end)
    indexed_map
  end

  defp extract_map_splits_local(lsitofsplits) do
    pipestrings = Enum.filter(lsitofsplits, fn str ->
        is_binary(str) and String.contains?(str, "|")
      end)
    unique = Enum.uniq(pipestrings)
    indexed_map =
        unique
        |> Enum.with_index()
        |> Map.new(fn {string, index} ->
          value = "\\#{index + 1}" # "\1", "\2", "\3"...
          {string, value}
        end)
    indexed_map
  end


  defp expand_splittet(splitonparen, mapofsplits) do
    expand_splittet_helper({[],[],splitonparen}, mapofsplits)
  end

  defp expand_splittet_helper(splittupple, mapofsplits) do
    case splittupple do
      {init, [], []} ->
        init
      {init, [], final} ->
        [head | tail] = final
        expand_splittet_helper({init, head, tail}, mapofsplits)
      {init, mid, final}  ->
        if Map.has_key?(mapofsplits, mid) do
          # mid is a key in the map, so we need to expand it
          value = Map.get(mapofsplits, mid)
          # split the value on "|"
          parts = String.split(value, "|")
          Enum.map(parts, fn part ->
            replcedvals = Enum.map(final, fn
              ^mid -> part
              str -> str
            end)
            expand_splittet_helper({init ++ [part], [], replcedvals}, mapofsplits)
            #Enum.map(replcedvals, fn str ->
            #  expand_splittet_helper({init ++ [part], [], str}, mapofsplits)
            #end)
          end)

            #Enum.map(final, fn str ->
            #  String.replace(str, mid, part) end) end
          #Enum.map(splitmid, fn c -> expand_splittet_helper({init, c, final}, mapofsplits) end)

        else
          # mid is not a key in the map, so we just add it to init and continue
          new_init = init ++ [mid]
          if final == [] do
            new_init
          else
            [head | tail] = final
            expand_splittet_helper({new_init, head, tail}, mapofsplits)
          end
        end

    end
  end




end
