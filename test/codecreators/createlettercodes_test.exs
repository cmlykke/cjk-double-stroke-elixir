
defmodule Createlettercodes_test do
    use ExUnit.Case

    alias CjkDoubleStroke.Datagenerators.StaticData
    alias CjkDoubleStroke.Idsidentifier.Createlettercodes



    test "test get_letter qwert" do
        q45 = StaticData.get_letter("45")
        assert q45 == "q"

        w44 = StaticData.get_letter("44")
        assert w44 == "w"

        e43 = StaticData.get_letter("43")
        assert e43 == "e"

        r42 = StaticData.get_letter("42")
        assert r42 == "r"

        t41 = StaticData.get_letter("41")
        assert t41 == "t"

        t4 = StaticData.get_letter("4")
        assert t4 == "t"
    end


    test "test get_letter yuiop" do
        p35 = StaticData.get_letter("35")
        assert p35 == "p"

        o34 = StaticData.get_letter("34")
        assert o34 == "o"

        i33 = StaticData.get_letter("33")
        assert i33 == "i"

        u32 = StaticData.get_letter("32")
        assert u32 == "u"

        y31 = StaticData.get_letter("31")
        assert y31 == "y"

        y3 = StaticData.get_letter("3")
        assert y3 == "y"
    end

    test "test get_letter asdfg" do
        a55 = StaticData.get_letter("55")
        assert a55 == "a"

        s54 = StaticData.get_letter("54")
        assert s54 == "s"

        d53 = StaticData.get_letter("53")
        assert d53 == "d"

        f52 = StaticData.get_letter("52")
        assert f52 == "f"

        g51 = StaticData.get_letter("51")
        assert g51 == "g"

        g5 = StaticData.get_letter("5")
        assert g5 == "g"
    end


    test "test get_letter mlkjh" do
        m15 = StaticData.get_letter("15")
        assert m15 == "m"

        l14 = StaticData.get_letter("14")
        assert l14 == "l"

        k13 = StaticData.get_letter("13")
        assert k13 == "k"

        j12 = StaticData.get_letter("12")
        assert j12 == "j"

        h11 = StaticData.get_letter("11")
        assert h11 == "h"

        h1 = StaticData.get_letter("1")
        assert h1 == "h"
    end

    test "test get_letter nbvcx" do
        x25 = StaticData.get_letter("25")
        assert x25 == "x"

        c24 = StaticData.get_letter("24")
        assert c24 == "c"

        v23 = StaticData.get_letter("23")
        assert v23 == "v"

        b22 = StaticData.get_letter("22")
        assert b22 == "b"

        n21 = StaticData.get_letter("21")
        assert n21 == "n"

        n2 = StaticData.get_letter("2")
        assert n2 == "n"
    end

end
