defmodule ReadstaticfilesTest do
  use ExUnit.Case

  alias CjkDoubleStroke.Datagenerators.Readfiles.Readstaticfiles

  test "read_cedict returns list of {traditional, simplified} pairs" do
    pairs = Readstaticfiles.read_cedict()
    assert is_list(pairs)
    assert length(pairs) == 125013
    assert hd(pairs) == {"11區", "11区"}            # Test first pair
    assert List.last(pairs) == {"𰻞𰻞麵", "𰻝𰻝面"}  # Test last pair
  end

  test "read_radicals returns set of non-ASCII characters from radicals.txt" do
    set = Readstaticfiles.read_radicals_set()
    assert is_struct(set, MapSet)
    expected = MapSet.new([?⼀, ?⼁, ?⼂])
    assert MapSet.subset?(expected, set),
          "Expected radicals are missing from the set"
  end

  test "read_words_json returns valid json starting with array" do
    content = Readstaticfiles.read_words_json()
    assert String.trim(content) |> String.starts_with?("[")
  end

  test "read_file works for custom path" do
    content = Readstaticfiles.read_file("webfiles/info.txt")
    assert content =~ "fetched 2026-06-25"
  end

  test "binary files like xlsx are readable" do
    content = Readstaticfiles.read_hongbing_xlsx()
    assert is_binary(content)
    assert byte_size(content) > 0
  end
end
