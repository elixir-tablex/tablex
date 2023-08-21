defmodule RuleParser do
  import NimbleParsec
  import Tablex.Parser.Rule

  use Tablex.Parser.Expression.List

  defparsec(:parse, rules(), [])
end

defmodule Tablex.Parser.RuleTest do
  use ExUnit.Case, async: true
  alias Tablex.Parser.Rule
  doctest Rule

  test "it works with a simple rule" do
    assert {:ok, [rules: [[1, input: [1], output: [1]]]], _, _, _, _} =
             parse("1 1 || 1")
  end

  test "it works with numbers" do
    assert {:ok, [rules: [[1, input: [103, 19.5], output: [4]]]], _, _, _, _} =
             parse("1 103 19.5 || 4")
  end

  test "it works" do
    assert {:ok, [rules: [[1, input: ["test", :any], output: [4]]]], _, _, _, _} =
             parse("1 test - || 4")
  end

  describe "Expression of any (`-`)" do
    test "works" do
      assert {:ok,
              [
                rules: [
                  [1, input: [:any], output: [true]]
                ]
              ], _, _, _, _} = parse("1 - || true")
    end
  end

  describe "Expression with quotes" do
    test "works" do
      text = ~S(50 "Hello!" "||" "null" || null)

      assert {:ok,
              [
                rules: [
                  [50, input: ["Hello!", "||", "null"], output: [nil]]
                ]
              ], _, _, _, _} = parse(text)
    end
  end

  describe "Two output expressions" do
    test "works" do
      assert {:ok,
              [
                rules: [
                  [1, input: [:any], output: [true, :any]]
                ]
              ], _, _, _, _} = parse("1 - || true -")
    end
  end

  describe "Range expression" do
    test "works" do
      assert {:ok,
              [
                rules: [
                  [1, input: [1..10], output: [true]]
                ]
              ], _, _, _, _} = parse("1 1..10 || Y")
    end
  end

  defp parse(source) do
    RuleParser.parse(source)
  end
end
