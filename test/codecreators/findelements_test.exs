defmodule Findelements_test do
  use ExUnit.Case

  alias CjkDoubleStroke.Datagenerators.StaticData

  alias CjkDoubleStroke.Idsidentifier.Findelements


  test "find stroeks" do
    res = Findelements.splitstrokes()
    assert res == 10
  end

end
