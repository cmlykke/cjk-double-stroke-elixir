defmodule CjkDoubleStroke.Datagenerators.Readfiles.Readstaticfiles do
  @staticfiles_dir Path.join([__DIR__, "../../../staticfiles"])

  def read_file(relative_path) do
    File.read!(Path.join(@staticfiles_dir, relative_path))
  end

  def read_radicals, do: read_file("customfiles/radicals.txt")
  def read_cedict, do: read_file("webfiles/cedict_ts.u8")
  def read_codepoint_sequence, do: read_file("webfiles/codepoint-character-sequence.txt")
  def read_global_wordfreq, do: read_file("webfiles/global_wordfreq_release_UTF-8.txt")
  def read_hongbing_xlsx, do: read_file("webfiles/hongbing.xlsx")
  def read_ids, do: read_file("webfiles/ids.txt")
  def read_info, do: read_file("webfiles/info.txt")
  def read_tzai, do: read_file("webfiles/tzai.txt")
  def read_words_json, do: read_file("webfiles/words.json")
end