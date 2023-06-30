# test Tablex.Optimizer.RemoveDuplication.optimize/1
defmodule Tablex.Optimizer.RemoveDuplicationTest do
  alias Tablex.Optimizer.RemoveDuplication

  use ExUnit.Case
  doctest RemoveDuplication

  describe "optimize/1" do
    test "works" do
      table =
        Tablex.new("""
        F a.b  || hit
        1 <10  || T
        2 <10  || T
        3 >50  || T
        """)

      assert %{
               rules: [
                 [1, {:input, [<: 10]}, {:output, [true]}],
                 [2, {:input, [>: 50]}, {:output, [true]}]
               ]
             } = RemoveDuplication.optimize(table)
    end

    test "works with `reverse_merge` hit policy" do
      table =
        Tablex.new("""
        R a.b  || hit
        1 -    || T
        2 <10  || F
        3 <10  || F
        4 >50  || T
        """)

      assert %{
               rules: [
                 [1, {:input, [:any]}, {:output, [true]}],
                 [2, {:input, [<: 10]}, {:output, [false]}],
                 [3, {:input, [>: 50]}, {:output, [true]}]
               ]
             } = RemoveDuplication.optimize(table)
    end
  end
end
