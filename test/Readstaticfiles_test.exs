defmodule ReadstaticfilesTest do
  use ExUnit.Case

  alias CjkDoubleStroke.Datagenerators.Readfiles.Readstaticfiles

  test "read_radicals returns content starting with expected radicals" do
    content = Readstaticfiles.read_radicals()
    assert String.starts_with?(content, "⼀\t⼁\t⼂")
  end

  test "read_info returns content with expected keys" do
    content = Readstaticfiles.read_info()
    assert content =~ "conway file:"
    assert content =~ "cedict file:"
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