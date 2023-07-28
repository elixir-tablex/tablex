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
  end
end
