
defmodule UtilTest do
  use ExUnit.Case

  alias CjkDoubleStroke.Utils


  test "unwrap_nested" do
    test1 = Utils.unwrap_nested([["a", "b"], ["c", "d"]])
    assert test1 == [["a", "b"], ["c", "d"]]
    test2 = Utils.unwrap_nested([["a", "b"]])
    assert test2 == [["a", "b"]]
    test3 = Utils.unwrap_nested([])
    assert test3 == [[]]
    test4 = Utils.unwrap_nested([["a", "b", ["c"]], ["d", "e"]])
    assert test4 == [["a", "b", ["c"]], ["d", "e"]]
    test5 = Utils.unwrap_nested([[["a", "b", ["c"],["f", "g"]],["h"]], ["d", "e"]])
    assert test5 == [["a", "b", ["c"], ["f", "g"]], ["h"], ["d", "e"]]
  end






  test "removes shape characters" do

    res1 = Utils.remove_shape_chars("一⿰二三⿱四五")
    assert res1 == "一二三四五"

  end


  test "test that something is chinese" do
    assert Utils.is_chinese?("😭") == false
    assert Utils.is_chinese?("") == false
    assert Utils.is_chinese?("A") == false
    assert Utils.is_chinese?("⿰") == false
    assert Utils.is_chinese?("⿱") == false

    assert Utils.is_chinese?("一") == true
    assert Utils.is_chinese?("二") == true
    assert Utils.is_chinese?("三") == true
    assert Utils.is_chinese?("四") == true
    assert Utils.is_chinese?("五") == true
  end

end
