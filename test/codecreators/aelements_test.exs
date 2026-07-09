defmodule Aelements_test do
  use ExUnit.Case

  alias CjkDoubleStroke.Datagenerators.StaticData

  alias CjkDoubleStroke.Idsidentifier.Idsnested

  alias CjkDoubleStroke.Idsidentifier.Aelements


  test "find char_init_ids_matches" do
    res = Idsnested.char_init_ids_matches("是", ["氵", "日"])
    res2 = Aelements.get_elements()
    assert res == {"是", ["12134"], ["日"], ["2511"], "251112134"}
  end


end
