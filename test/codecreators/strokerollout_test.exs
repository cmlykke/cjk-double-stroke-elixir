defmodule Strokerollout_test do
  use ExUnit.Case

  alias CjkDoubleStroke.Datagenerators.StaticData

  alias CjkDoubleStroke.Idsidentifier.Strokerollout


    test "Strokerollout.stroke_rollout_multistr/1 -- 日一龰" do
      res = Strokerollout.stroke_rollout_multistr("日一龰")
      assert res == ["251112134"]

    end

    test "Strokerollout.stroke_rollout_multistr/1 -- 米⺄十" do
      res = Strokerollout.stroke_rollout_multistr("米⺄十")
      assert res == ["431234512"]

    end

    test "Strokerollout.stroke_rollout/1 no branching" do
      res = Strokerollout.stroke_rollout("是")
      assert res == ["251112134"]

    end

    # U+6CD0	泐	441(52|552)53
    test "Strokerollout.stroke_rollout/1 basic branching" do
      res = Strokerollout.stroke_rollout("泐")
      #assert res == [["441", "52", "53"], ["441", "552", "53"]]
      assert res == ["4415253", "44155253"]
    end

    # U+6D41	流	441(|4)154325
    test "Strokerollout.stroke_rollout/1 nothing or something" do
      res = Strokerollout.stroke_rollout("流")
      #assert res == [["441", "", "154325"], ["441", "4", "154325"]]
      assert res == ["441154325", "4414154325"]
    end

    # U+6D45	浅*	44111(|1)(534|543)
    test "Strokerollout.stroke_rollout/1 multiple branching" do
      res = Strokerollout.stroke_rollout("浅")

      #assert res == [[["44111", "", "534"],
      #                ["44111", "", "543"]],
      #               [["44111", "1", "534"],
      #                ["44111", "1", "543"]]]
      assert res == ["44111534", "44111543", "441111534", "441111543"]

    end

    # U+6DDC	淜	441(3511|3544)\1
    test "Strokerollout.stroke_rollout/1 double branching first" do
      res = Strokerollout.stroke_rollout("淜")
      #assert res == [["441", "3511", "3511"], ["441", "3544", "3544"]]
      assert res == ["44135113511", "44135443544"]
    end

    # U+7053	灓	(1|4)111251(554234|554444)\22534
    test "Strokerollout.stroke_rollout/1 double branching second" do
      res = Strokerollout.stroke_rollout("灓")
      #assert res == [
      #  [["1", "111251", "554234", "554234", "2534"],
      #   ["1", "111251", "554444", "554444", "2534"]],
      #  [["4", "111251", "554234", "554234", "2534"],
      #   ["4", "111251", "554444", "554444", "2534"]]]
      assert res ==
        ["11112515542345542342534",
         "11112515544445544442534",
         "41112515542345542342534",
         "41112515544445544442534"]
    end

end
