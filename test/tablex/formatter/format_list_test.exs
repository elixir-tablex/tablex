defmodule Tablex.Formatter.FormatListTest do
  use ExUnit.Case

  alias Tablex.Formatter

  describe "Formatting list values" do
    test "works" do
      table =
        Tablex.new("""
        M name || items
        1 Alex || [food]
        """)

      assert Formatter.to_s(table) == "M name || items\n1 Alex || [food]"
    end

    test "works with nested list" do
      table =
        Tablex.new("""
        M name || items
        1 Alex || [[food]]
        """)

      assert Formatter.to_s(table) == "M name || items\n1 Alex || [[food]]"
    end

    test "works with more complex nested lists" do
      table =
        Tablex.new("""
        M name || items
        1 Alex || [[food]]
        2 Bob  || [[food], [drink]]
        3 Mike || [[1, 2], [3, 4]]
        4 Zoe  || [one]
        """)

      assert Formatter.to_s(table) ==
               "M name || items\n1 Alex || [[food]]\n2 Bob  || [[food],[drink]]\n3 Mike || [[1,2],[3,4]]\n4 Zoe  || [one]"
    end
  end
end
