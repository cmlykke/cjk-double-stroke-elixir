defmodule CjkDoubleStroke.Datagenerators.StaticDataTest do
  use ExUnit.Case

  alias CjkDoubleStroke.Datagenerators.StaticData

  # Tests for the fast lookup getters (theoretical - data will be provided)

  test "get_conway/1 returns strokes for a char" do
    item = StaticData.get_conway("一")
    assert item == "1"
  end

  test "get_ids/1 returns ids sequence for a char" do
    item = StaticData.get_ids("一")
    assert item == "一"
    item = StaticData.get_ids("是")
    assert item == "⿱日𤴓"
  end

  test "get_ids/1 result of 簧" do
    item = StaticData.get_ids("簧")
    assert item == "⿱竹黄[G] ⿱竹黃[TJK]"
  end

  test "get_hongbing/1 returns frequency for a char" do
    item = StaticData.get_hongbing("一")
    assert item == "35278860"
  end

  test "get_global_freq/1 returns count for a char" do
    # assert StaticData.get_global_freq("一") == "12345"
    item = StaticData.get_global_freq("胡良成")
    assert item == "25"
  end

  test "get_tzai/1 returns count for a char" do
    # assert StaticData.get_tzai("一") == "99"
    item = StaticData.get_tzai("鷍")
    assert item == "4"
  end

  test "get_word_freq/1 returns frequency for a word" do
    # assert StaticData.get_word_freq("测试") == "777"
    item = StaticData.get_global_freq("胡良成")
    assert item == "25"
  end

  test "has_radical?/1 returns true for a known radical" do
    # assert StaticData.has_radical?("⾡") == true
    item = StaticData.has_radical?("⾡")
    assert item == true
  end

  test "get_* functions return nil for unknown keys" do
    assert StaticData.get_conway("UNKNOWN") == nil
    assert StaticData.get_ids("UNKNOWN") == nil
    assert StaticData.get_hongbing("UNKNOWN") == nil
    assert StaticData.get_global_freq("UNKNOWN") == nil
    assert StaticData.get_tzai("UNKNOWN") == nil
    assert StaticData.get_word_freq("UNKNOWN") == nil
    assert StaticData.has_radical?("UNKNOWN") == false
  end
end
