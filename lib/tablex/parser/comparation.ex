defmodule Tablex.Parser.Expression.Comparation do
  @moduledoc false

  import NimbleParsec
  import Tablex.Parser.Space
  import Tablex.Parser.Expression.Numeric

  def comparation do
    choice([
      string("!="),
      string(">="),
      string(">"),
      string("<="),
      string("<")
    ])
    |> optional_space()
    |> concat(numeric())
    |> reduce({__MODULE__, :trans_comparation, []})
  end

  @doc false
  def trans_comparation([op, num]) do
    {:"#{op}", num}
  end
end
