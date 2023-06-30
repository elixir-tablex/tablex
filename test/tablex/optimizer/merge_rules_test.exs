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
  end
end
