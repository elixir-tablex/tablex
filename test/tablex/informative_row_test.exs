defmodule Tablex.InformativeRowTest do
  alias Tablex.Table
  use ExUnit.Case
  doctest_file("guides/informative_row.md")

  describe "Informative row" do
    test "works" do
      table =
        Tablex.new("""
        F foo      || bar
          (string) || (string)
        1 test     || test
        """)

      assert %Table{
               inputs: [
                 %{name: :foo, type: :string, desc: nil}
               ],
               outputs: [
                 %{name: :bar, type: :string, desc: nil}
               ]
             } = table
    end

    test "works for output-only tables" do
      table =
        Tablex.new("""
        C || bar
          || (string)
        1 || test
        """)

      assert %Table{
               inputs: [],
               outputs: [
                 %{name: :bar, type: :string, desc: nil}
               ]
             } = table
    end
  end
end
