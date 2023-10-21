defmodule Tablex.Decider.ReteTest do
  alias Tablex.Decider.Rete

  use ExUnit.Case

  describe "decide/3" do
    test "works" do
      table =
        Tablex.new("""
        F   day (string)                         weather (string) || activity
        1   Monday,Tuesday,Wednesday,Thursday    rainy            || read
        2   Monday,Tuesday,Wednesday,Thursday    -                || read,walk
        3   Friday                               sunny            || soccer
        4   Friday                               -                || swim
        5   Saturday                             -                || "watch movie",games
        6   Sunday                               -                || null
        """)

      assert %{"activity" => "read"} = Rete.decide(table, %{day: "Monday", weather: "rainy"})
    end
  end
end
