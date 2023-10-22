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

Benchee.run(%{
  "rete"    => fn -> Tablex.Decider.Rete.decide(table, %{day: "Monday", weather: "rainy"}) end,
  "naive" => fn -> Tablex.Decider.Naive.decide(table, %{day: "Monday", weather: "rainy"}) end
})
