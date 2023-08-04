defmodule Tablex.Optimizer.RemoveDeadRulesTest do
  alias Tablex.Optimizer.RemoveDeadRules

  use ExUnit.Case

  describe "dead rule removal" do
    test "works" do
      table =
        Tablex.new("""
        F a.b  || hit
        1 <10  || T
        2 -    || F
        3 >10  || F
        """)

      assert %{
               rules: [
                 [1, {:input, [<: 10]}, {:output, [true]}],
                 [2, {:input, [:any]}, {:output, [false]}]
               ]
             } = RemoveDeadRules.optimize(table)
    end

    test "works with comparison (<)" do
      table =
        Tablex.new("""
        F a.b  || hit
        1 <10  || T
        2 <5   || F
        3 -    || F
        """)

      assert %{
               rules: [
                 [1, {:input, [<: 10]}, {:output, [true]}],
                 [3, {:input, [:any]}, {:output, [false]}]
               ]
             } = RemoveDeadRules.optimize(table)
    end

    test "works with comparison (<=)" do
      table =
        Tablex.new("""
        F a.b  || hit
        1 <=10 || T
        2 <5   || F
        3 -    || F
        """)

      assert %{
               rules: [
                 [1, {:input, [<=: 10]}, {:output, [true]}],
                 [3, {:input, [:any]}, {:output, [false]}]
               ]
             } = RemoveDeadRules.optimize(table)
    end

    test "works with comparison (>)" do
      table =
        Tablex.new("""
        F a.b  || hit
        1 >50  || T
        2 >=51 || F
        3 -    || F
        """)

      assert %{
               rules: [
                 [1, {:input, [{:>, 50}]}, {:output, [true]}],
                 [3, {:input, [:any]}, {:output, [false]}]
               ]
             } = RemoveDeadRules.optimize(table)
    end

    test "works with comparison (>=)" do
      table =
        Tablex.new("""
        F a.b  || hit
        1 >=50 || T
        2 >60  || F
        3 -    || F
        """)

      assert %{
               rules: [
                 [1, {:input, [{:>=, 50}]}, {:output, [true]}],
                 [3, {:input, [:any]}, {:output, [false]}]
               ]
             } = RemoveDeadRules.optimize(table)
    end

    test "works with lists" do
      table =
        Tablex.new("""
        F a.b   || hit
        1 1,2,3 || T
        2 1     || F
        3 2,3   || F
        """)

      assert %{
               rules: [
                 [1, {:input, [[1, 2, 3]]}, {:output, [true]}]
               ]
             } = RemoveDeadRules.optimize(table)
    end

    test "works with `merge` hit_policy" do
      table =
        Tablex.new("""
        M a.b   || hit
        1 1,2,3 || T
        2 1     || F
        3 2     || F
        """)

      assert %{
               rules: [
                 [1, {:input, [[1, 2, 3]]}, {:output, [true]}]
               ]
             } = RemoveDeadRules.optimize(table)
    end
  end
end
