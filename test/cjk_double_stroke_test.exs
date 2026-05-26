defmodule CjkDoubleStrokeTest do
  use ExUnit.Case, async: true

  describe "add/2" do
    test "adds two positive numbers" do
      assert CjkDoubleStroke.add(5, 3) == 8
      assert CjkDoubleStroke.add(10, 20) == 30
      assert CjkDoubleStroke.add(0, 0) == 0
    end

    test "adds negative numbers" do
      assert CjkDoubleStroke.add(-5, 3) == -2
      assert CjkDoubleStroke.add(-10, -20) == -30
    end

    test "adds float numbers" do
      assert CjkDoubleStroke.add(3.5, 2.5) == 6.0
    end

    test "returns error for invalid input" do
      assert CjkDoubleStroke.add("hello", 5) == {:error, :invalid_input}
      assert CjkDoubleStroke.add(5, "world") == {:error, :invalid_input}
      assert CjkDoubleStroke.add(nil, 10) == {:error, :invalid_input}
    end
  end
end
