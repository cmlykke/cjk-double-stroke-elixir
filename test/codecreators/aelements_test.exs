defmodule Aelements_test do
  use ExUnit.Case

  alias CjkDoubleStroke.Datagenerators.StaticData

  alias CjkDoubleStroke.Idsidentifier.Idsnested

  alias CjkDoubleStroke.Idsidentifier.Aelements

  test "aelement_keys returns set of all keys from the aelement map" do
    keys = StaticData.aelement_keys()
    assert is_struct(keys, MapSet)
    assert MapSet.size(keys) == 42
    assert MapSet.member?(keys, "木")
    assert MapSet.member?(keys, "⽊")
    assert MapSet.member?(keys, "⿱口止")
    assert MapSet.member?(keys, "⿰⿱𠂊亅⿱𠂊亅")
    assert MapSet.member?(keys, "⻟")
    assert MapSet.member?(keys, "車")
    assert MapSet.member?(keys, "⾞")
    # all keys should allow lookup
    assert Enum.all?(keys, fn k -> StaticData.get_aelement_conway(k) != nil end)
  end

  test "test get_aelement_conway 木" do
    test1 = StaticData.get_aelement_conway("木")
    assert test1 == "1234"
  end

  test "test get_aelement_conway ⽊" do
    test1 = StaticData.get_aelement_conway("⽊")
    assert test1 == "1234"
  end

  test "test get_aelement_conway ⿱口止" do
    test1 = StaticData.get_aelement_conway("⿱口止")
    assert test1 == "251(215|2121|2134)"
  end

  test "test get_aelement_conway 足" do
    test1 = StaticData.get_aelement_conway("足")
    assert test1 == "251(215|2121|2134)"
  end

  test "test get_aelement_conway ⻊" do
    test1 = StaticData.get_aelement_conway("⻊")
    assert test1 == "2512(121|134)"
  end

  test "test get_aelement_conway ⾜" do
    test1 = StaticData.get_aelement_conway("⾜")
    assert test1 == "251(215|2121|2134)"
  end

  test "test get_aelement_conway ⿰⿱𠂊亅⿱𠂊亅" do
    test1 = StaticData.get_aelement_conway("⿰⿱𠂊亅⿱𠂊亅")
    assert test1 == "314314"
  end

  test "test get_aelement_conway 竹" do
    test1 = StaticData.get_aelement_conway("竹")
    assert test1 == "314314"
  end

  test "test get_aelement_conway ⺮" do
    test1 = StaticData.get_aelement_conway("⺮")
    assert test1 == "314314"
  end

  test "test get_aelement_conway 虫" do
    test1 = StaticData.get_aelement_conway("虫")
    assert test1 == "251214"
  end

  test "test get_aelement_conway ⾍" do
    test1 = StaticData.get_aelement_conway("⾍")
    assert test1 == "251214"
  end

  test "test get_aelement_conway 手" do
    test1 = StaticData.get_aelement_conway("手")
    assert test1 == "3112"
  end

  test "test get_aelement_conway ⼿" do
    test1 = StaticData.get_aelement_conway("⼿")
    assert test1 == "3112"
  end

  test "test get_aelement_conway 扌" do
    test1 = StaticData.get_aelement_conway("扌")
    assert test1 == "121"
  end

  test "test get_aelement_conway ⺘" do
    test1 = StaticData.get_aelement_conway("⺘")
    assert test1 == "121"
  end

  test "test get_aelement_conway 目" do
    test1 = StaticData.get_aelement_conway("目")
    assert test1 == "25111"
  end

  test "test get_aelement_conway 言" do
    test1 = StaticData.get_aelement_conway("言")
    assert test1 == "(1|4)111251"
  end

  test "test get_aelement_conway 訁" do
    test1 = StaticData.get_aelement_conway("訁")
    assert test1 == "(1|4)111251"
  end

  test "test get_aelement_conway ⾔" do
    test1 = StaticData.get_aelement_conway("⾔")
    assert test1 == "(1|4)111251"
  end

  test "test get_aelement_conway ⿱⿰②丶③" do
    test1 = StaticData.get_aelement_conway("⿱⿰②丶③")
    assert test1 == "(554234|554444)"
  end

  test "test get_aelement_conway 糸" do
    test1 = StaticData.get_aelement_conway("糸")
    assert test1 == "(554234|554444)"
  end

  test "test get_aelement_conway 糹" do
    test1 = StaticData.get_aelement_conway("糹")
    assert test1 == "(554234|554444)"
  end

  test "test get_aelement_conway ⺯" do
    test1 = StaticData.get_aelement_conway("⺯")
    assert test1 == "(554234|554444)"
  end

  test "test get_aelement_conway ⽷" do
    test1 = StaticData.get_aelement_conway("⽷")
    assert test1 == "(554234|554444)"
  end

  test "test get_aelement_conway ⿱人⿻⿱一⿱十一丷" do
    test1 = StaticData.get_aelement_conway("⿱人⿻⿱一⿱十一丷")
    assert test1 == "34112431"
  end

  test "test get_aelement_conway 金" do
    test1 = StaticData.get_aelement_conway("金")
    assert test1 == "34112431"
  end

  test "test get_aelement_conway ⾦" do
    test1 = StaticData.get_aelement_conway("⾦")
    assert test1 == "34112431"
  end

  test "test get_aelement_conway ⿰𠁣𠃛" do
    test1 = StaticData.get_aelement_conway("⿰𠁣𠃛")
    assert test1 == "25112511"
  end

  test "test get_aelement_conway 門" do
    test1 = StaticData.get_aelement_conway("門")
    assert test1 == "25112511"
  end

  test "test get_aelement_conway ⾨" do
    test1 = StaticData.get_aelement_conway("⾨")
    assert test1 == "25112511"
  end

  test "test get_aelement_conway ⿹⑥灬" do
    test1 = StaticData.get_aelement_conway("⿹⑥灬")
    assert test1 == "(12|21)11254444"
  end

  test "test get_aelement_conway 馬" do
    test1 = StaticData.get_aelement_conway("馬")
    assert test1 == "(12|21)11254444"
  end

  test "test get_aelement_conway ⾺" do
    test1 = StaticData.get_aelement_conway("⾺")
    assert test1 == "(12|21)11254444"
  end

  test "test get_aelement_conway ⿱人⿱丶⑤" do
    test1 = StaticData.get_aelement_conway("⿱人⿱丶⑤")
    assert test1 == "34(1|4)(51154|511211)"
  end

  test "test get_aelement_conway 食" do
    test1 = StaticData.get_aelement_conway("食")
    assert test1 == "34(1|4)(51154|511211)"
  end

  test "test get_aelement_conway 飠" do
    test1 = StaticData.get_aelement_conway("飠")
    assert test1 == "34(1|4)(51154|511211)"
  end

  test "test get_aelement_conway ⾷" do
    test1 = StaticData.get_aelement_conway("⾷")
    assert test1 == "34(1|4)(51154|511211)"
  end

  test "test get_aelement_conway ⻝" do
    test1 = StaticData.get_aelement_conway("⻝")
    assert test1 == "34(1|4)(51154|511211)"
  end

  test "test get_aelement_conway ⻞" do
    test1 = StaticData.get_aelement_conway("⻞")
    assert test1 == "34(1|4)(51154|511211)"
  end

  test "test get_aelement_conway ⻟" do
    test1 = StaticData.get_aelement_conway("⻟")
    assert test1 == "34(1|4)(51154|511211)"
  end

  test "test get_aelement_conway 車" do
    test1 = StaticData.get_aelement_conway("車")
    assert test1 == "1251112"
  end

  test "test get_aelement_conway ⾞" do
    test1 = StaticData.get_aelement_conway("⾞")
    assert test1 == "1251112"
  end

  test "find char_init_ids_matches" do
    res = Idsnested.char_init_ids_matches("是", ["氵", "日"])
    res2 = Aelements.get_elements()
    lettermap = Aelements.get_letters()
    assert res == {"是", ["12134"], ["日"], ["2511"], "251112134"}
  end
end
