defmodule Idsnested_test do
  use ExUnit.Case

  alias CjkDoubleStroke.Datagenerators.StaticData

  alias CjkDoubleStroke.Idsidentifier.Idsnested


  test "Idsnested.ids_init_search/1 works" do
    #assert Idsnested.ids_init_search("一") == ["一"]
    #assert Idsnested.ids_init_search("") == []

    # Use a safe character or escape if needed
    res = Idsnested.ids_init_search("是")
    assert res == [["日", "一", "龰"]]
    # If you really need the em dash, write it as:
    # assert Idsnested.ids_init_search("\u2014") == ["\u2014"]
  end

  # U+7C78	籸	⿰米卂[GT]	⿰米⿹⺄𠂇[K]
  test "籸 tested to investigate handling 十 vs 𠂇" do
    res = Idsnested.ids_init_search("籸")
    assert res ==
      [["米", "⺄", "十"], ["米", "⺄", "𠂇"], ["米", "⺄", "𠂇"]]
  end

  # U+7C90	粐	⿰米户[G]	⿰米戸[J]
  # 粐 # der findes ikke andre -- forskellen paa 戸 og 户 er at 户 har en streg mere paa
  test "粐 tested to investigate handling 戸 vs 户" do
    res = Idsnested.ids_init_search("粐")
    assert res == [["米", "丶", "尸"], ["米", "一", "尸"]]
      #["米", "丶", "尸", "[", "G", "]", " ", "米", "一", "尸", "[", "J", "]"]
  end



  #U+7C27	簧	⿱竹黄[G]	⿱竹黃[TJK]

  #test "簧 tested to investigate handling 艹 vs 艹+一" do
  #  res = Idsnested.ids_init_search("簧")
  #  assert res == []
  #end

# ["𠂊", "亅", " ", "𠂉", "亅", " ", "𠂉", "丨", " ", "丿", "一", "亅", " ",
#  "丿", "乛", "亅", "𠂊", "亅", " ", "𠂉", "亅", " ", "𠂉", "丨", " ", "丿", "一", "亅", " ",
# "丿", "乛", "亅", "十", "丨", "一", "由", "八", " ", "十", "丨", "一", "田", "八", " ", "𠂊", "亅", " ", "𠂉", "亅", " ", "𠂉", "丨", " ", "丿", "一", "亅", " ", "丿", "乛", "亅", "𠂊", "亅", " ", "𠂉", "亅", " ", "𠂉", "丨", " ", "丿", "一", "亅", " ", "丿", "乛", "亅", "廿", "一", "由", "八", " ", "廿", "一", "田", "八"]



  test "Idsnested.ids_init_search/1 2nd test" do

    # Use a safe character or escape if needed
    res = Idsnested.ids_init_search("人")
    assert res == ["人"]
  end

  test "Idsnested.ids_init_search/1 3nd test" do

    # Use a safe character or escape if needed
    res = Idsnested.ids_init_search("撥")
    assert res == [["扌", "②", "③", "弓", "𠘧", "又"], ["扌", "②", "③", "弓", "几", "又"]]
  end

end
