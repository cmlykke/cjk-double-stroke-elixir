defmodule Idsnested_test do
  use ExUnit.Case

  alias CjkDoubleStroke.Datagenerators.StaticData

  alias CjkDoubleStroke.Idsidentifier.Idsnested


  test "Idsnested.ids_init_search/1 works" do
    assert Idsnested.ids_init_search("一") == ["一"]
    assert Idsnested.ids_init_search("") == []

    # Use a safe character or escape if needed
    res = Idsnested.ids_init_search("是")
    assert res == ["日", "一", "龰"]
    # If you really need the em dash, write it as:
    # assert Idsnested.ids_init_search("\u2014") == ["\u2014"]
  end

end
