

defmodule CjkService do
  def readLines() do
    lines =
      "resources/official-cjk-files/babelstone-co-uk-cjk-ids.txt"
      |> File.read!()
      |> String.split(~r/\r?\n/, trim: true)
  end

  def

  def numOfLines() do
    res = readLines()
      |> length
  end

end








