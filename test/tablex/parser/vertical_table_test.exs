defmodule Tablex.Parser.VerticalTableParserTest do
  use ExUnit.Case, async: true

  describe "Parsing a vertical table" do
    test "works" do
      v_table = """
      ====
      F    || 1         2        3
      age  || >50       -        -
      i    || >8.0      >5.0     -
      ====
      test || positive  positive negative
      act  || hospital  observe  rest
      """

      h_table = """
      F age  i    || test      act
      1 >50  >8.0 || positive  hospital
      2 -    >5.0 || positive  observe
      3 -    -    || negative  rest
      """

      assert_same(v_table, h_table)
    end

    test "works without collect hit policy" do
      v_table = """
      ====
      C     || 1    2
      day   || Mon  -
      rainy || -    T
      ====
      act   || run  read
      """

      h_table = """
      C  day  rainy || act
      1  Mon  -     || run
      2  -    T     || read
      """

      assert_same(v_table, h_table)
    end

    test "works without inputs" do
      v_table = """
      ====
      C     || 1    2
      ====
      act   || run  read
      """

      h_table = """
      C || act
      1 || run
      2 || read
      """

      assert_same(v_table, h_table)
    end
  end

  defp assert_same(v_table, h_table) do
    vtb = Tablex.new(v_table) |> Map.from_struct() |> Map.drop([:table_dir])
    htb = Tablex.new(h_table) |> Map.from_struct() |> Map.drop([:table_dir])

    assert vtb == htb
  end
end
