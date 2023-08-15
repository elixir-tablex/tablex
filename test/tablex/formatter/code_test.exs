defmodule Tablex.Formatter.CodeTest do
  use ExUnit.Case

  describe "Formatting a code value" do
    test "works" do
      code = """
      C || t
      1 || `now()`
      2 || `1 + 3`
      """

      assert code |> Tablex.new() |> Tablex.Formatter.to_s() == String.trim_trailing(code)
    end
  end
end
