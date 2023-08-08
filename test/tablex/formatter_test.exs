defmodule Tablex.FormatterTest do
  alias Tablex.Formatter

  use ExUnit.Case
  doctest Formatter

  describe "to_s/1" do
    test "works" do
      table =
        Tablex.new("""
        F   Day (string)                         Weather (string) || Activity
        1   Monday,Tuesday,Wednesday,Thursday    rainy            || read
        2   Monday,Tuesday,Wednesday,Thursday    -                || read,walk
        3   Friday                               sunny            || soccer
        4   Friday                               -                || swim
        5   Saturday                             -                || "watch movie",games
        6   Sunday                               -                || null
        """)

      assert_format(table)
    end

    test "works with informative rows" do
      table =
        Tablex.new("""
        F   Day                                  Weather          || Activity
            (string, weekday)                    -                || -
        1   Monday,Tuesday,Wednesday,Thursday    rainy            || read
        2   Monday,Tuesday,Wednesday,Thursday    -                || read,walk
        3   Friday                               sunny            || soccer
        4   Friday                               -                || swim
        5   Saturday                             -                || "watch movie",games
        6   Sunday                               -                || null
        """)

      assert_format(table)
    end

    test "works with empty list" do
      table =
        Tablex.new("""
        C   foo || bar
        1   1   || []
        2   2   || 1,2
        """)

      assert_format(table)
    end

    test "update rule ids" do
      table = %Tablex.Table{
        hit_policy: :first_hit,
        inputs: [
          %Tablex.Variable{
            name: :id,
            label: "store.id",
            desc: "Store Id",
            type: :integer,
            path: [:store]
          },
          %Tablex.Variable{
            name: :id,
            label: "quest.brand.id",
            desc: "Brand Id",
            type: :integer,
            path: [:quest, :brand]
          },
          %Tablex.Variable{
            name: :picking_only,
            label: "quest.pickingAndDelivery.pickingOnly",
            desc: "Picking-only?",
            type: :bool,
            path: [:quest, :picking_and_delivery]
          },
          %Tablex.Variable{
            name: :delivery_type,
            label: "quest.pickingAndDelivery.deliveryType",
            desc: "Delivery Type",
            type: :string,
            path: [:quest, :picking_and_delivery]
          },
          %Tablex.Variable{
            name: :type,
            label: "quest.type",
            desc: nil,
            type: :string,
            path: [:quest]
          }
        ],
        outputs: [
          %Tablex.Variable{
            name: :enabled,
            label: "enabled",
            desc: nil,
            type: :undefined,
            path: []
          }
        ],
        rules: [
          [1, {:input, [:any, :any, true, :any, :any]}, {:output, [false]}],
          [2, {:input, [:any, 602, :any, "VENTEL", :any]}, {:output, [false]}],
          [3, {:input, [:any, [719, 749], :any, :any, :any]}, {:output, [true]}],
          [4, {:input, [:any, ~c"x|", :any, :any, :any]}, {:output, [true]}],
          [5, {:input, [:any, 131, :any, :any, :any]}, {:output, [true]}],
          [6, {:input, [:any, 601, :any, :any, :any]}, {:output, [true]}],
          [7, {:input, [:any, 729, :any, :any, :any]}, {:output, [true]}],
          [8, {:input, [:any, 724, :any, :any, :any]}, {:output, [true]}],
          [9, {:input, [:any, 723, :any, :any, :any]}, {:output, [true]}],
          [9, {:input, [:any, 106, :any, :any, :any]}, {:output, [true]}],
          [9, {:input, [:any, 244, :any, :any, :any]}, {:output, [true]}],
          [9, {:input, [:any, 735, :any, :any, :any]}, {:output, [true]}],
          [9, {:input, [:any, 700, :any, :any, :any]}, {:output, [true]}],
          [9, {:input, [:any, 732, :any, :any, :any]}, {:output, [true]}],
          [10, {:input, [2434, :any, :any, :any, :any]}, {:output, [true]}],
          [10, {:input, [2390, :any, :any, :any, :any]}, {:output, [true]}],
          [10, {:input, [19849, :any, :any, :any, :any]}, {:output, [true]}],
          [10, {:input, [20923, :any, :any, :any, :any]}, {:output, [true]}],
          [
            10,
            {:input,
             [
               [20922, 20921, 20920],
               :any,
               :any,
               :any,
               :any
             ]},
            {:output, [true]}
          ],
          [11, {:input, [123, 719, :any, :any, :any]}, {:output, [true]}],
          [12, {:input, [:any, :any, :any, :any, :any]}, {:output, [false]}]
        ],
        valid?: :undefined,
        table_dir: :h
      }

      assert_format(table)
    end
  end

  describe "Formatting vertical tables" do
    test "works" do
      table =
        Tablex.new("""
        ====
        F    || 1         2        3
        age  || >50       -        -
        i    || >8.0      >5.0     -
        ====
        test || positive  positive negative
        act  || hospital  observe  rest
        """)

      assert_format(table)
    end
  end

  describe "Formatting horizontal tables" do
    test "works" do
      table =
        Tablex.new("""
        C || region       id host        port
        1 || Singapore    1  example.com 2020
        1 || Singapore    2  example.com 2025
        2 || Japan        1  example.com 2021
        2 || Japan        2  example.com 2022
        2 || "Hong Kong"  1  example.com 2027
        2 || "Hong Kong"  2  example.com 2028
        2 || USA          2  example.com 2023
        2 || USA          3  example.com 2026
        """)

      assert_format(table)
    end
  end

  describe "Formatting ambitional strings" do
    test "works" do
      table =
        Tablex.new("""
        C || value
        1 || "1983-04-01"
        """)

      assert_format(table)
    end
  end

  defp assert_format(table) do
    # table |> Formatter.to_s() |> IO.puts()
    assert table |> Formatter.to_s() |> Tablex.new() == fix_ids(table)
  end

  defp fix_ids(table) do
    rules =
      table.rules
      |> Stream.with_index(1)
      |> Enum.map(fn {[_ | rest], index} -> [index | rest] end)

    %{table | rules: rules}
  end
end
