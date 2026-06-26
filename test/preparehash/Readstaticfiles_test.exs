defmodule ReadstaticfilesTest do
  use ExUnit.Case

  alias CjkDoubleStroke.Datagenerators.Readfiles.Readstaticfiles

  test "read_cedict --- traditional / simplified word pairs" do
    pairs = Readstaticfiles.read_cedict()
    assert is_list(pairs)
    assert length(pairs) == 125013
    assert hd(pairs) == {"11區", "11区"}            # Test first pair
    assert List.last(pairs) == {"𰻞𰻞麵", "𰻝𰻝面"}  # Test last pair
  end

  test "read_radicals --- set of all radicals" do
    set = Readstaticfiles.read_radicals_set()
    assert is_struct(set, MapSet)
    # Use strings instead of ?char syntax
    expected = MapSet.new(["⼀", "⼁", "⼂"])
    assert MapSet.subset?(expected, set),
           "Expected radicals are missing from the set"
  end

  test "read_conway_strokes --- all characters with stroke sequences" do
    pairs = Readstaticfiles.read_conway_strokes()
    assert is_list(pairs)
    assert length(pairs) == 28165
    # Test first pair
    assert hd(pairs) == {"〇", "5"}
    # Test last pair
    assert List.last(pairs) == {"𬺓", "212134521234123452134"}
  end

  test "read_ids --- all characters with IDs sequences" do
    pairs = Readstaticfiles.read_ids()
    assert is_list(pairs)
    assert length(pairs) == 88937
    # Test first pair
    assert hd(pairs) == {"α", "α"}
    # Test last pair
    assert List.last(pairs) == {"𪘀", "⿰齒幷"}
  end

  test "read_hongbing_csv --- simplified character frequencies" do
    pairs = Readstaticfiles.read_hongbing_csv()
    assert is_list(pairs)
    assert length(pairs) == 14975
    assert hd(pairs) == {"的", "76938354"}       # First pair
    assert List.last(pairs) == {"飵", "1"}       # Last pair
  end

  test "read_global_wordfreq --- simplified word frequencies" do
    pairs = Readstaticfiles.read_global_wordfreq()
    assert is_list(pairs)
    assert length(pairs) == 1048576
    # Test first pair
    assert hd(pairs) == {"第", "2002074595"}
    # Test last pair
    assert List.last(pairs) == {"胡良成", "25"}
  end

  test "read_tzai --- traditional character frequencies" do
    pairs = Readstaticfiles.read_tzai()
    assert is_list(pairs)
    assert length(pairs) == 13060
    # Test first pair
    assert hd(pairs) == {"的", "6538132"}
    # Test last pair
    assert List.last(pairs) == {"鷍", "4"}
  end

  test "read_words_json_stream --- traditional word frequencies" do
    #stream = Readstaticfiles.read_words_json_stream()
    #pairs = stream |> Enum.take(50)
    pairs = Readstaticfiles.read_words_json_stream()
            |> Enum.to_list()          # Convert the whole stream to list
    assert is_list(pairs)
    assert length(pairs) == 146162
    # Test first pair
    assert hd(pairs) == {"的", "284589"}
    # value at index 59999
    assert Enum.at(pairs, 59999) == {"代表色", "3"}
    # Test last pair
    assert List.last(pairs) == {"••／ｂｉｎ／ｅｔｃ／ａｓｐａｃ／ｂｉｎ／ｕｓｒ／", "1"}

  end


end
