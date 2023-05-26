defmodule Tablex.Parser.Expression.Comparison do
  @moduledoc false

  import NimbleParsec
  import Tablex.Parser.Space
  import Tablex.Parser.Expression.Numeric

  def comparison do
    choice([
      string("!="),
      string(">="),
      string(">"),
      string("<="),
      string("<")
    ])
    |> optional_space()
    |> concat(numeric())
    |> reduce({__MODULE__, :trans_comparison, []})
  end

  @doc false
  def trans_comparison([op, num]) do
    {:"#{op}", num}
  end
end
