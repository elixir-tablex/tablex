defmodule Tablex.OptimizerTest do
  use ExUnit.Case

  doctest Tablex.Optimizer

  describe "optimize/1" do
    test "works" do
      table =
        Tablex.new("""
        F a.b  || hit
        1 <10  || T
        2 -    || F
        """)

      assert Tablex.Optimizer.optimize(table) == table
    end
  end
end
