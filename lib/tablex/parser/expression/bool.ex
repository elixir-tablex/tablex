defmodule Tablex.Parser.Expression.Bool do
  @moduledoc false

  import NimbleParsec
  import Tablex.Parser.Space

  def bool do
    choice([
      true_exp(),
      false_exp()
    ])
  end

  def true_exp do
    choice([
      string("Y"),
      string("T"),
      string("YES"),
      string("yes"),
      string("true")
    ])
    |> lookahead(eow())
    |> replace(true)
  end

  def false_exp do
    choice([
      string("N"),
      string("F"),
      string("NO"),
      string("no"),
      string("false")
    ])
    |> lookahead(eow())
    |> replace(false)
  end
end
