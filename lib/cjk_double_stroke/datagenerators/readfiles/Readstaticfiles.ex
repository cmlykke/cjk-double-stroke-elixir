defmodule CjkDoubleStroke.Datagenerators.Readfiles.Readstaticfiles do
  @staticfiles_dir Path.join([__DIR__, "../../../staticfiles"])

  @spec read_file(String.t()) :: String.t()
  def read_file(relative_path) do
    File.read!(Path.join(@staticfiles_dir, relative_path))
  end

  @spec non_ascii_chars_set(String.t()) :: MapSet.t(non_neg_integer())
  def non_ascii_chars_set(string) when is_binary(string) do
    string
    |> String.to_charlist()
    |> Enum.filter(fn char -> char > 127 end)
    |> MapSet.new()
  end

  @spec contains_non_ascii?(String.t()) :: boolean()
  def contains_non_ascii?(string) when is_binary(string) do
    String.match?(string, ~r/[^\x00-\x7F]/u)
  end

  @spec read_radicals_set() :: MapSet.t(non_neg_integer())
  def read_radicals_set do
    "customfiles/radicals.txt"
    |> read_file()
    |> non_ascii_chars_set()
  end

  @type cedict_pair() :: {String.t(), String.t()}
  @spec read_cedict() :: [cedict_pair()]
  def read_cedict do
    read_file("webfiles/cedict_ts.u8")
    |> String.split("\n", trim: true)
    |> Enum.reject(&String.starts_with?(&1, "#"))
    |> Enum.map(fn line ->
        [traditional, simplified | _] = String.split(line, ~r/\s+/, trim: true)
        {traditional, simplified}                    # ← Tuple
      end)
    |> Enum.filter(fn {traditional, simplified} ->   # ← Tuple pattern
        contains_non_ascii?(traditional) || contains_non_ascii?(simplified)
      end)
  end

  @spec read_codepoint_sequence() :: binary()
  def read_codepoint_sequence, do: read_file("webfiles/codepoint-character-sequence.txt")
  def read_global_wordfreq, do: read_file("webfiles/global_wordfreq_release_UTF-8.txt")
  def read_hongbing_xlsx, do: read_file("webfiles/hongbing.xlsx")
  def read_ids, do: read_file("webfiles/ids.txt")
  def read_tzai, do: read_file("webfiles/tzai.txt")
  def read_words_json, do: read_file("webfiles/words.json")
end
