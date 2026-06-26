defmodule CjkDoubleStroke.Datagenerators.StaticDataTest do
  use ExUnit.Case

  alias CjkDoubleStroke.Datagenerators.StaticData

  # Tests for the fast lookup getters (theoretical - data will be provided)

  test "get_conway/1 returns strokes for a char" do
    assert StaticData.get_conway("一") == "some_strokes_value"
  end

  test "get_ids/1 returns ids sequence for a char" do
    assert StaticData.get_ids("一") == "some_ids_sequence"
  end

  test "get_hongbing/1 returns frequency for a char" do
    assert StaticData.get_hongbing("一") == "42"
  end

  test "get_global_freq/1 returns count for a char" do
    assert StaticData.get_global_freq("一") == "12345"
  end

  test "get_tzai/1 returns count for a char" do
    assert StaticData.get_tzai("一") == "99"
  end

  test "get_word_freq/1 returns frequency for a word" do
    assert StaticData.get_word_freq("测试") == "777"
  end

  test "has_radical?/1 returns true for a known radical" do
    assert StaticData.has_radical?("一") == true
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
