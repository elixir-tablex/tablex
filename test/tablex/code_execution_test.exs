defmodule Tablex.CodeExecutionTest do
  use ExUnit.Case
  import DoctestFile

  doctest_file("guides/code_execution.md")

  describe "Exuecting code in an output field" do
    test "works" do
      table =
        Tablex.new("""
        F x || plus_1  square
        1 - || `x + 1` `x * x`
        """)

      assert %{plus_1: 5, square: 16} = run(table, x: 4)
    end

    test "works with collect hit policy" do
      table =
        Tablex.new("""
        C a  b   || div
        1 -  0   || "b is zero"
        2 -  !=0 || `a / b`
        """)

      assert [%{div: "b is zero"}] = run(table, a: 5, b: 0)
      assert [%{div: 5.0}] = run(table, a: 5.0, b: 1)
    end

    test "works with collect hit policy and nested inputs" do
      table =
        Tablex.new("""
        C a.a  b.b   || div
        1 -    0     || "b.b is zero"
        2 -    !=0   || `a.a / b.b`
        """)

      assert [%{div: "b.b is zero"}] = run(table, a: 5, b: %{b: 0})
      assert [%{div: 5.0}] = run(table, a: %{a: 5.0}, b: %{b: 1})
    end

    test "works with `merge` hit policy" do
      table =
        Tablex.new("""
        M day_of_week || "Go to Library"  Volunteer  Blogging
        1 1           || T                -          -
        2 2           || F                T          -
        3 -           || F                F          `week_of_month == 4`
        """)

      assert %{go_to_library: true, volunteer: false, blogging: false} ==
               run(table, day_of_week: 1, week_of_month: 1)

      assert %{go_to_library: true, volunteer: false, blogging: true} ==
               run(table, day_of_week: 1, week_of_month: 4)
    end
  end

  defp run(table, args) do
    {ret, _} =
      Tablex.CodeGenerate.generate(table)
      |> Code.eval_string(args)

    ret
  end
end
