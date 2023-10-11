defmodule Tablex.Parser.VariableTest do
  use ExUnit.Case

  alias Tablex.Parser.Variable
  import Variable
  doctest Variable

  test "it works" do
    assert %{name: :F, label: "F"} = parse("F")
  end

  test "it works for multi-letter char" do
    assert %{name: :Test, label: "Test"} = parse("Test")
  end

  describe "Variable name cases" do
    test "are kept" do
      assert %{name: :TestFoo} = parse("TestFoo")
      assert %{name: :Test_Foo} = parse("Test-Foo")
      assert %{name: :Test__Foo} = parse("Test-_Foo")
      assert %{name: :Test__Foo, path: [:myBar]} = parse("myBar.Test-_Foo")
    end
  end

  test "it works with string type" do
    assert %{name: :Test, type: :string} = parse("Test (string)")
  end

  test "it works with descriptions" do
    assert %{
             name: :Test,
             label: "Test",
             type: :string,
             desc: "describing the test"
           } = parse("Test (string, describing the test)")
  end

  test "it works with quoted strings" do
    assert %{
             name: :Test__var_test,
             label: "Test  var test",
             type: :string,
             desc: "describing the test"
           } = parse(~S["Test  var test" (string, describing the test)])
  end

  describe "With nested variables" do
    test "it works with nested variables" do
      assert %{
               name: :b,
               path: [:a],
               label: "a.b"
             } = parse("a.b")
    end

    test "it works at two levels deep" do
      assert %{
               name: :c,
               path: [:a, :b],
               label: "a.b.c"
             } = parse("a.b.c")
    end
  end

  defp parse(text) do
    assert {:ok, [var], _, _, _, _} = VariableParser.parse(text)
    var
  end
end

defmodule VariableParser do
  import NimbleParsec
  import Tablex.Parser.Variable

  defparsec(:parse, variable(), [])
end
