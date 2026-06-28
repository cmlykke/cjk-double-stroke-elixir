
defmodule UtilTest do
  use ExUnit.Case

  alias CjkDoubleStroke.Utils

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
