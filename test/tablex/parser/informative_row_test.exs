defmodule Tablex.Parser.InformativeRowTest do
  use ExUnit.Case

  describe "Parsing informative row" do
    test "works" do
      assert [[string: nil], [integer: nil]] == parse("  (string) || (integer)")
    end

    test "works with description" do
      assert [[string: "foo"], [integer: "bar bar"]] ==
               parse("  (string, foo) || (integer, bar bar)")
    end

    test "works with multiple stubs" do
      assert [[string: "foo", string: "foz"], [integer: "bar bar", bool: "baz"]] ==
               parse("  (string, foo) (string, foz) || (integer, bar bar) (bool, baz)")
    end

    test "works with ANY" do
      assert [[undefined: nil], [undefined: nil]] == parse("  - || -")
    end
  end

  defp parse(text) do
    assert {:ok, [var], _, _, _, _} = InfoRowParser.parse(text)
    var
  end
end

defmodule InfoRowParser do
  import NimbleParsec
  import Tablex.Parser.InformativeRow

  defparsec(:parse, informative_row(), [])
end
