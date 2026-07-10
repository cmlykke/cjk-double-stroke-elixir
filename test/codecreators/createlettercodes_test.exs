
defmodule Createlettercodes_test do
    use ExUnit.Case
    alias CjkDoubleStroke.Idsidentifier.Createlettercodes


    test "test getsum" do
        res = Createlettercodes.get_sum()
        assert res == 10
    end
end
