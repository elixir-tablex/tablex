defmodule Tablex.Decider.ReteTest do
  alias Tablex.Decider.Rete

  use ExUnit.Case

  describe "decide/3" do
    test "works with a basic case" do
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

      assert %{activity: "read"} = Rete.decide(table, %{day: "Monday", weather: "rainy"})
    end

    test "first hit" do
      table =
        Tablex.new("""
        F   age (integer)  || f (float)
        1   > 60           || 3.0
        2   50..60         || 2.5
        3   31..49         || 2.0
        5   -              || 0
        """)

      assert %{f: 0} == Rete.decide(table, age: 30)
      assert %{f: 2.5} == Rete.decide(table, age: 55)
      assert %{f: 0} = Rete.decide(table, age: 22)
      assert %{f: 0} = Rete.decide(table, age: 17)
      assert %{f: 0} = Rete.decide(table, age: 1)
    end

    test "holidays calculation" do
       table =
        Tablex.new("""
        F   age (integer)  years_of_service    || holidays (integer)
        1   >=60           -                   || 3
        2   45..59         <30                 || 2
        3   -              >=30                || 22
        4   <18            -                   || 5
        5   -              -                   || 10
        """)

      assert %{holidays: 10} == Rete.decide(table, age: 46, years_of_service: 30)
      assert %{holidays: 5} == Rete.decide(table, age: 17, years_of_service: 5)
      assert %{holidays: 10} == Rete.decide(table, age: 22)
    end
  end
end
