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
  end

  defp assert_format(table) do
    # table |> Formatter.to_s() |> IO.puts()
    assert table |> Formatter.to_s() |> Tablex.new() == table
  end
end
