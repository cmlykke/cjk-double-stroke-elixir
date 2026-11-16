
defmodule CjkServiceTest do
  use ExUnit.Case, async: true

  describe "read cjk file" do

    test "reads all lines" do
      assert CjkService.numOfLines() == 98039
    end

  end

end











