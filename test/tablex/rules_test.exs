defmodule Tablex.RulesTest do
  alias Tablex.Rules

  use ExUnit.Case
  doctest Rules

  test "getting rules from a table" do
    table =
      Tablex.new("""
      F store.id  quest.brand.id quest.pickingAndDelivery.pickingOnly quest.pickingAndDelivery.deliveryType  quest.type || enabled
        (integer, Store Id) (integer, Brand Id) (bool, Picking-only?) (string, Delivery Type) (string)                  || -
      1 -         -              T                                    -                                      -          || F
      2 -         602            -                                    VENTEL                                 -          || F
      3 -         719,749        -                                    -                                      -          || T
      4 -         120,124        -                                    -                                      -          || T
      5 -         131            -                                    -                                      -          || T
      6 -         601            -                                    -                                      -          || T
      7 -         729            -                                    -                                      -          || T
      8 -         724            -                                    -                                      -          || T
      9 -         723            -                                    -                                      -          || T
      9 -         106            -                                    -                                      -          || T
      9 -         244            -                                    -                                      -          || T
      9 -         735            -                                    -                                      -          || T
      9 -         700            -                                    -                                      -          || T
      9 -         732            -                                    -                                      -          || T
      10 2434     -              -                                    -                                      -          || T
      10 2390     -              -                                    -                                      -          || T
      10 19849    -              -                                    -                                      -          || T
      10 20923    -              -                                    -                                      -          || T
      10 20922,20921  - - - - || T
      11 -        719            -                                    -                                      -          || T
      12 -        -              -                                    -                                      -          || F
      """)

    assert [
             %Tablex.Rules.Rule{
               id: 12,
               inputs: [
                 {[:store, :id], :any},
                 {[:quest, :brand, :id], :any},
                 {[:quest, :pickingAndDelivery, :pickingOnly], :any},
                 {[:quest, :pickingAndDelivery, :deliveryType], :any},
                 {[:quest, :type], :any}
               ],
               outputs: [{[:enabled], false}]
             },
             %Tablex.Rules.Rule{
               id: 11,
               inputs: [
                 {[:store, :id], :any},
                 {[:quest, :brand, :id], 719},
                 {[:quest, :pickingAndDelivery, :pickingOnly], :any},
                 {[:quest, :pickingAndDelivery, :deliveryType], :any},
                 {[:quest, :type], :any}
               ],
               outputs: [{[:enabled], true}]
             },
             %Tablex.Rules.Rule{
               id: 3,
               inputs: [
                 {[:store, :id], :any},
                 {[:quest, :brand, :id], [719, 749]},
                 {[:quest, :pickingAndDelivery, :pickingOnly], :any},
                 {[:quest, :pickingAndDelivery, :deliveryType], :any},
                 {[:quest, :type], :any}
               ],
               outputs: [{[:enabled], true}]
             }
           ] == Rules.get_rules(table, %{quest: %{brand: %{id: 719}}})
  end

  describe "update_rule_by_input/3" do
    test "updates a rule" do
      table =
        Tablex.new("""
        F value || result
        1 >5    || big
        2 -     || small
        """)
        |> Rules.update_rule_by_input(%{value: ">5"}, %{result: "large"})

      assert table.rules == [
               [1, {:input, [>: 5]}, {:output, ["large"]}],
               [2, {:input, [:any]}, {:output, ["small"]}]
             ]
    end

    test "updates a rule when input is nested" do
      table =
        Tablex.new("""
        F foo.value || result
        1 >5        || big
        2 -         || small
        """)
        |> Rules.update_rule_by_input(%{foo: %{value: ">5"}}, %{result: "large"})

      assert table.rules == [
               [1, {:input, [>: 5]}, {:output, ["large"]}],
               [2, {:input, [:any]}, {:output, ["small"]}]
             ]
    end

    test "inserts a new rule when it doesn't exist" do
      table =
        Tablex.new("""
        F value || result
        1 >5    || big
        2 -     || small
        """)
        |> Rules.update_rule_by_input(%{value: ">10"}, %{result: "large"})

      assert table.rules == [
               [1, {:input, [>: 10]}, {:output, ["large"]}],
               [2, {:input, [>: 5]}, {:output, ["big"]}],
               [3, {:input, [:any]}, {:output, ["small"]}]
             ]
    end
  end
end
