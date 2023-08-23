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

    test "works for a more complex example" do
      table =
        Tablex.new("""
        ====
        M                 || 1    2   3
        target.company_id || -    -   -
        target.store_id   || 2053 2053 -
        ====
        feature1          || -    yes  no
        feature2          || -    yes  no
        feature3          || no   -   yes
        feature4.enabled  || -    yes  no
        feature4.km       || -    0.3  10000
        """)

      expected_output = %{
        feature1: true,
        feature2: true,
        feature3: false,
        feature4: %{enabled: true, km: 0.3}
      }

      assert expected_output == Tablex.decide(table, target: %{store_id: 2053})

      assert expected_output ==
               table
               |> Tablex.Optimizer.optimize()
               |> Tablex.decide(target: %{store_id: 2053})

      assert """
             ====
             M                 || 1    2
             target.company_id || -    -
             target.store_id   || 2053 -
             ====
             feature1          || yes  no
             feature2          || yes  no
             feature3          || no   yes
             feature4.enabled  || yes  no
             feature4.km       || 0.3  10000
             """
             |> String.trim_trailing() ==
               table
               |> Tablex.Optimizer.optimize()
               |> Tablex.Formatter.to_s()
    end

    test "works for a more complex, reerse_merge, example" do
      table =
        Tablex.new("""
        ====
        R                 || 3    2   1
        target.company_id || -    -   -
        target.store_id   || 2053 2053 -
        ====
        feature1          || -    yes  no
        feature2          || -    yes  no
        feature3          || no   -   yes
        feature4.enabled  || -    yes  no
        feature4.km       || -    0.3  10000
        """)

      expected_output = %{
        feature1: true,
        feature2: true,
        feature3: false,
        feature4: %{enabled: true, km: 0.3}
      }

      assert expected_output == Tablex.decide(table, target: %{store_id: 2053})

      assert expected_output ==
               table
               |> Tablex.Optimizer.optimize()
               |> Tablex.decide(target: %{store_id: 2053})

      assert """
             ====
             R                 || 1     2
             target.company_id || -     -
             target.store_id   || -     2053
             ====
             feature1          || no    yes
             feature2          || no    yes
             feature3          || yes   no
             feature4.enabled  || no    yes
             feature4.km       || 10000 0.3
             """
             |> String.trim_trailing() ==
               table
               |> Tablex.Optimizer.optimize()
               |> Tablex.Formatter.to_s()
    end
  end
end
