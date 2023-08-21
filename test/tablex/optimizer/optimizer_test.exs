defmodule Tablex.OptimizerTest do
  use ExUnit.Case

  doctest Tablex.Optimizer

  describe "optimize/1" do
    test "works" do
      table =
        Tablex.new("""
        F a.b  || hit hours
        1 <10  || T   [[1, 2], [3, 4]]
        2 -    || F   []
        """)

      assert Tablex.Optimizer.optimize(table) == table
    end
  end
end
