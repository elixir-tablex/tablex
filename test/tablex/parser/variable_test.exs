defmodule Tablex.Parser.VariableTest do
  use ExUnit.Case
  import Tablex.Parser.Variable
  doctest Tablex.Parser.Variable

  test "it works" do
    assert {:ok, [f: :undefined], "", %{}, {1, 0}, 1} == parse("F")
  end

  test "it works for multi-letter char" do
    assert {:ok, [test: :undefined], "", %{}, {1, 0}, 4} == parse("Test")
  end

  test "it underscores" do
    assert {:ok, [test_foo: :undefined], "", %{}, {1, 0}, 7} == parse("TestFoo")
    assert {:ok, [test_foo: :undefined], "", %{}, {1, 0}, 8} == parse("Test-Foo")
    assert {:ok, [test_foo: :undefined], "", %{}, {1, 0}, 9} == parse("Test-_Foo")
  end

  test "it works with string type" do
    assert {:ok, [test: :string], "", %{}, {1, 0}, 13} == parse("Test (string)")
  end

  test "it works with descriptions" do
    assert {:ok, [test: :string], "", %{}, {1, 0}, 34} ==
             parse("Test (string, describing the test)")
  end

  test "it works with quoted strings" do
    assert {:ok, [test_var_test: :string], "", %{}, {1, 0}, 46} ==
             parse(~S["Test  var test" (string, describing the test)])
  end

  defp parse(text) do
    VariableParser.parse(text)
  end
end

defmodule VariableParser do
  import NimbleParsec
  import Tablex.Parser.Variable

  defparsec(:parse, variable(), [])
end
