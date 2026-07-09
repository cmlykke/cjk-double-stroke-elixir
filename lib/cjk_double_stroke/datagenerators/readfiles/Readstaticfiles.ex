defmodule CjkDoubleStroke.Datagenerators.Readfiles.Readstaticfiles do
  @staticfiles_dir Path.join([__DIR__, "../../../staticfiles"])

  def read_file(relative_path) do
    File.read!(Path.join(@staticfiles_dir, relative_path))
  end

  def non_ascii_chars_set(string) when is_binary(string) do
    string
    |> String.graphemes()                    # Split into Unicode characters
    |> Enum.filter(fn char ->
        String.to_charlist(char) |> hd() > 127   # Keep only non-ASCII
      end)
    |> MapSet.new()
  end

  def contains_non_ascii?(string) when is_binary(string) do
    String.match?(string, ~r/[^\x00-\x7F]/u)
  end

  defp remove_ascii(string) when is_binary(string) do
    string
    |> String.to_charlist()
    |> Enum.reject(fn char -> char <= 127 end)   # Remove ASCII (0-127)
    |> List.to_string()
  end

  defp starts_with_ascii?(line) do
    case String.at(line, 0) do
      nil -> true
      char ->
        # ASCII range: 0-127
        char < "Ā"   # Anything before Ā (U+0100) is ASCII
    end
  end

  @spec read_radicals_set() :: MapSet.t(String.t())
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

  @type chinese_char_conway() :: String.t() # single Unicode character
  @type codepoint_pair() :: {chinese_char_conway(), String.t()}
  @spec read_conway_strokes() :: [codepoint_pair()]
  def read_conway_strokes do
    #read_file("webfiles/codepoint-character-sequence.txt")
    res1 = read_conway_strokes_helper("webfiles/codepoint-character-sequence.txt")
    res2 = read_conway_strokes_helper("customfiles/customconway.txt")
    res1 ++ res2
  end

  defp read_conway_strokes_helper(filepath) do
        read_file(filepath)
    |> String.split("\n", trim: true)
    |> Enum.filter(&String.starts_with?(&1, "U+"))
    |> Enum.map(fn line ->
        [_, char, strokes | _] = String.split(line, ~r/\s+/, trim: true)
        # Remove all ASCII characters from the first item (char)
        cleaned_char = remove_ascii(char)
        {cleaned_char, strokes}
      end)
  end


  @type chinese_char_simpwordfreq() :: String.t() # single Unicode character
  @type simpwordfreq_pair() :: {chinese_char_simpwordfreq(), String.t()}
  @spec read_global_wordfreq() :: [simpwordfreq_pair()]
  def read_global_wordfreq do
    read_file("webfiles/global_wordfreq_release_UTF-8.txt")
    |> String.replace_prefix("\uFEFF", "")
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
        case String.split(line, ~r/\s+/, trim: true) do
          [char, count | _] -> {char, count}
          [single]          -> {single, "0"}     # fallback for malformed lines
          _                 -> nil
        end
      end)
    |> Enum.reject(&is_nil/1)                    # Remove any bad lines
  end


  @type hongbing_pair() :: {String.t(), String.t()}
  @spec read_hongbing_csv() :: [hongbing_pair()]
  def read_hongbing_csv do
    Path.expand("../../../../lib/staticfiles/webfiles/hongbing.csv", __DIR__)
    |> File.stream!()
    |> CSV.decode!(headers: false, strip: true)
    |> Enum.drop(1)
    |> Enum.filter(fn
        [_, char | _] when is_binary(char) and char != "" and char != " " -> true
        _ -> false
      end)
    |> Enum.map(fn row ->
        [_, char, frequency | _] = row
        {String.trim(char), String.trim(frequency)}
      end)
  end


  @type chinese_char_ids() :: String.t() # single Unicode character
  @type ids_pair() :: {chinese_char_ids(), String.t()}
  @spec read_ids() :: [ids_pair()]
  def read_ids do
    res = read_ids_helper("webfiles/ids.txt")
    res2 = read_ids_helper("customfiles/customids.txt")
    res ++ res2
  end

  def read_ids_helper(filepath) do
    read_file(filepath)
    |> String.split("\n", trim: true)
    |> Enum.filter(&String.starts_with?(&1, "U+"))
    |> Enum.map(fn line ->
      # Split on whitespace
      parts = String.split(line, ~r/\s+/, trim: true)
      # First part is the codepoint (U+...), second is the char
      [_codepoint, char | rest] = parts
      # Join everything after the character into a single string
      idsseq = Enum.join(rest, " ")
      {char, idsseq}
    end)
  end

  def read_tzai do
    read_file("webfiles/tzai.txt")
    |> String.split("\n", trim: true)
    |> Enum.reject(&starts_with_ascii?/1)
    |> Enum.map(fn line ->
        [char, count | _] = String.split(line, ~r/\s+/, trim: true)
        {char, count}
      end)
  end



  def read_words_json_stream do
    path = Path.expand("../../../../lib/staticfiles/webfiles/words.json", __DIR__)

    File.stream!(path, [:read_ahead], 131_072)
    |> Stream.flat_map(fn chunk ->
      Regex.scan(~r/"word"\s*:\s*"([^"]+)"[^}]*?"frequency"\s*:\s*(\d+)/, chunk)
    end)
    |> Stream.map(fn [_, word, freq] ->
      {word, freq}
    end)
    |> Stream.uniq_by(fn {w, _} -> w end)
  end


end
