defmodule ExpressionParser do
  import NimbleParsec
  import Tablex.Parser.Expression

  use Tablex.Parser.Expression.List

  defparsec(:parse, expression(), [])
end

defmodule Tablex.Parser.ExpressionTest do
  alias Tablex.Parser.Expression

  use ExUnit.Case, async: true
  import ExpressionParser, only: [parse: 1]

  doctest Expression

  describe "Parsing boolean expressions" do
    test "works for `true`" do
      assert_parse("true", true)
    end

    test "works for `false`" do
      assert_parse("false", false)
    end
  end

  describe "Parsing numeric" do
    test "works with simple digits" do
      assert_parse("1", 1)
      assert_parse("01", 1)
      assert_parse("-90", -90)
    end

    test "works with digits and underscores" do
      assert_parse("1_000", 1000)
      assert_parse("1_000_000", 1_000_000)
      assert_parse("-3_2", -32)
    end

    test "works with floats" do
      assert_parse("3.44", 3.44)
      assert_parse("1.3415", 1.3415)
      assert_parse("-0.96", -0.96)
    end
  end

  describe "Parsing `nil`" do
    test "works" do
      assert_parse("null", nil)
    end
  end

  describe "Parsing `-`" do
    test "works" do
      assert_parse("- ", :any)
    end
  end

  describe "Parsing strings" do
    test "works" do
      assert_parse("test", "test")
    end

    test "stops before space" do
      assert_parse("foo bar", "foo")
    end
  end

  describe "Parsing quoted string" do
    test "works" do
      string = ~S("foo")
      assert_parse(string, "foo")
    end

    test "works with escaped quote" do
      string = ~S("a string that contains \" and \"!")
      assert_parse(string, "a string that contains \" and \"!")
    end

    test "works with number, null and any" do
      string = ~S("1.3415 null - ||")
      assert_parse(string, "1.3415 null - ||")
    end
  end

  describe "Parsing a list" do
    test "works" do
      assert_parse("a,b", ["a", "b"])
    end

    test "works with numbers" do
      assert_parse("1,3.44,-5", [1, 3.44, -5])
    end

    test "works with quoted strings" do
      assert_parse(~S(1," hello,world ",null), [1, " hello,world ", nil])
      assert_parse(~S("test",abc,false), ["test", "abc", false])
    end

    test "works with ranges" do
      assert_parse("100..200, >= 400", [100..200, {:>=, 400}])
    end

    test "works with empty lists" do
      assert_parse("[]", [])
    end

    test "works with single-element lists" do
      assert_parse("[1]", [1])
    end

    test "works with multi-element lists" do
      assert_parse("[1, 2]", [1, 2])
      assert_parse("[foo,bar]", ["foo", "bar"])
    end

    test "works with nested lists" do
      assert_parse("[[1, 2], [3, 4]]", [[1, 2], [3, 4]])
    end
  end

  describe "Parsing comparisons" do
    test "works with `>`" do
      assert_parse(">  1", {:>, 1})
      assert_parse("> 1", {:>, 1})
      assert_parse(">1", {:>, 1})
    end

    test "works with `>=`" do
      assert_parse(">= -5.0", {:>=, -5.0})
    end

    test "does not work with non-numeric values" do
      assert_parse("> abc", ">")
    end
  end

  describe "Parsing ranges" do
    test "works with integers" do
      assert_parse("1..100", 1..100)
    end

    test "does not work with floats" do
      assert_parse("1.0..5", 1.0)
    end

    test "works with underscores" do
      assert_parse("1_000..2_000", 1000..2000)
    end
  end

  defp assert_parse(code, expect) do
    assert {:ok, [^expect], _, _, _, _} = parse(code)
  end
end
