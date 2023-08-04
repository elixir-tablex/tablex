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
                 [1, {:input, [[1, 2, 3]]}, {:output, [true, true]}],
                 [2, {:input, [4]}, {:output, [false, true]}]
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
                 [1, {:input, [4]}, {:output, [false, true]}],
                 [2, {:input, [[1, 2, 3]]}, {:output, [true, true]}]
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
                 [1, {:input, [[2, 3], ["bar", "foo"]]}, {:output, [:any, true]}],
                 [2, {:input, [4, :any]}, {:output, [false, true]}]
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
                 [1, {:input, [[2, 3], ["bar", "foo"]]}, {:output, [false, true]}],
                 [2, {:input, [4, :any]}, {:output, [false, true]}]
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
                 [1, {:input, [4, :any]}, {:output, [false, true]}],
                 [2, {:input, [[2, 3], ["bar", "foo"]]}, {:output, [false, true]}]
               ]
             } = MergeRules.optimize(table)
    end
  end
end
