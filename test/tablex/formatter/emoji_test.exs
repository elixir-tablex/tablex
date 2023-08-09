defmodule Tablex.Formatter.EmojiTest do
  use ExUnit.Case

  describe "Formatting a table containing emojis" do
    test "works" do
      code = """
      C || flag  name      feature
      1 || "🇸🇬 " USA       yes
      2 || "🇺🇸 " Singapore no
      """

      assert code |> Tablex.new() |> Tablex.Formatter.to_s() == String.trim_trailing(code)
    end
  end
end
