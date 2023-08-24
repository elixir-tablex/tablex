defmodule MergeRules.MergeRulesTest do
  alias Tablex.Optimizer.MergeRules
  use ExUnit.Case

  describe "Merge rules" do
    test "works" do
      table =
        Tablex.new("""
        M a.b   || hit log
        1 2,3   || T   T
        2 1     || T   T
        """)

      assert %{
               rules: [
                 [1, {:input, [[1, 2, 3]]}, {:output, [true, true]}]
               ]
             } = MergeRules.optimize(table)
    end

    test "works when there are unrelavent rules between" do
      table =
        Tablex.new("""
        M a.b   || hit log
        1 2,3   || T   T
        2 4     || F   T
        3 1     || T   T
        """)

      assert %{
               rules: [
                 [1, {:input, [4]}, {:output, [false, true]}],
                 [2, {:input, [[1, 2, 3]]}, {:output, [true, true]}]
               ]
             } = MergeRules.optimize(table)
    end

    test "works with `reverse_merge` hit policy" do
      table =
        Tablex.new("""
        R a.b   || hit log
        1 1     || T   T
        2 4     || F   T
        3 2,3   || T   T
        """)

      assert %{
               rules: [
                 [1, {:input, [[1, 2, 3]]}, {:output, [true, true]}],
                 [2, {:input, [4]}, {:output, [false, true]}]
               ]
             } = MergeRules.optimize(table)
    end

    test "breaks lists and merges back" do
      table =
        Tablex.new("""
        M a.b  a.c      || hit log
        1 2,3  foo,bar  || -   T
        3 2    bar      || -   T
        """)

      assert %{
               rules: [
                 [1, {:input, [[2, 3], ["bar", "foo"]]}, {:output, [:any, true]}]
               ]
             } = MergeRules.optimize(table)
    end

    test "breaks lists and merges back, with something in the middle" do
      table =
        Tablex.new("""
        M a.b  a.c      || hit log
        1 2,3  foo,bar  || -   T
        2 4    -        || F   T
        3 2    bar      || -   T
        """)

      assert %{
               rules: [
                 [1, {:input, [4, :any]}, {:output, [false, true]}],
                 [2, {:input, [[2, 3], ["bar", "foo"]]}, {:output, [:any, true]}]
               ]
             } = MergeRules.optimize(table)
    end

    test "breaks lists and merges back, example 3" do
      table =
        Tablex.new("""
        M a.b  a.c      || hit log
        1 2,3  foo,bar  || F   T
        2 4    -        || F   T
        3 2    bar      || -   T
        """)

      assert %{
               rules: [
                 [1, {:input, [4, :any]}, {:output, [false, true]}],
                 [2, {:input, [[2, 3], ["bar", "foo"]]}, {:output, [false, true]}]
               ]
             } = MergeRules.optimize(table)
    end

    test "breaks lists and merges back, example 3, with `reverse_merge` hit policy" do
      table =
        Tablex.new("""
        R a.b  a.c      || hit log
        1 2    bar      || -   T
        2 4    -        || F   T
        3 2,3  foo,bar  || F   T
        """)

      assert %{
               rules: [
                 [1, {:input, [[2, 3], ["bar", "foo"]]}, {:output, [false, true]}],
                 [2, {:input, [4, :any]}, {:output, [false, true]}]
               ]
             } = MergeRules.optimize(table)
    end

    test "works with two dimentions" do
      table =
        Tablex.new("""
        M x n || value
        1 a 1 || T
        2 b 1 || T
        3 a 2 || T
        4 b 2 || T
        5 - - || F
        """)

      assert %{
               rules: [
                 [1, {:input, [["a", "b"], [1, 2]]}, {:output, [true]}],
                 [2, {:input, [:any, :any]}, {:output, [false]}]
               ]
             } = MergeRules.optimize(table)
    end

    test "works with two dimentions and `first_hit`" do
      table =
        Tablex.new("""
        F x n || value
        1 a 1 || T
        2 b 1 || T
        3 a 2 || T
        4 b 2 || T
        5 - - || F
        """)

      assert %{
               rules: [
                 [1, {:input, [["a", "b"], [1, 2]]}, {:output, [true]}],
                 [2, {:input, [:any, :any]}, {:output, [false]}]
               ]
             } = MergeRules.optimize(table)
    end

    test "works with two dimentions and `first_hit`, when there's another rule between" do
      table =
        Tablex.new("""
        F x n || value
        1 a 1 || T
        2 c 3 || test
        3 b 1 || T
        4 - - || F
        """)

      assert %{
               rules: [
                 [1, {:input, ["c", 3]}, {:output, ["test"]}],
                 [2, {:input, [["a", "b"], 1]}, {:output, [true]}],
                 [3, {:input, [:any, :any]}, {:output, [false]}]
               ]
             } = MergeRules.optimize(table)
    end

    test "should not merge two rules where there are other co-existing rules between" do
      table =
        Tablex.new("""
        F foo   bar || x
        1 false 1  || 1
        2 false -  || 2
        3 true  -  || 3
        4 -     -  || 2
        """)

      assert %{x: 3} == Tablex.decide(table, foo: true)
      assert %{x: 3} == table |> MergeRules.optimize() |> Tablex.decide(foo: true)

      assert %{
               rules: [
                 [1, {:input, [false, 1]}, {:output, [1]}],
                 [2, {:input, [true, :any]}, {:output, [3]}],
                 [3, {:input, [:any, :any]}, {:output, [2]}]
               ]
             } = MergeRules.optimize(table)
    end
  end
end
