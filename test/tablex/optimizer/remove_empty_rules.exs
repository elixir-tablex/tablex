defmodule Tablex.Optimizer.RemoveEmptyRulesTest do
  alias Tablex.Optimizer.RemoveEmptyRules

  use ExUnit.Case

  describe "Removing rules without meaningful values" do
    test "works" do
      table =
        Tablex.new("""
        M a.b   || hit log
        1 1,2,3 || T   T
        2 1     || F   -
        3 2,3   || -   -
        """)

      assert %{
               rules: [
                 [1, {:input, [[1, 2, 3]]}, {:output, [true, true]}],
                 [2, {:input, [1]}, {:output, [false, :any]}]
               ]
             } = RemoveEmptyRules.optimize(table)
    end
  end
end
