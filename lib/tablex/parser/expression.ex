defmodule Tablex.Parser.Expression do
  @moduledoc false

  use Tablex.Parser.Expression.List

  import NimbleParsec

  import Tablex.Parser.Expression.Any
  import Tablex.Parser.Expression.Numeric
  import Tablex.Parser.Expression.Range
  import Tablex.Parser.Expression.Bool
  import Tablex.Parser.Expression.ImpliedString
  import Tablex.Parser.Expression.QuotedString
  import Tablex.Parser.Expression.Null
  import Tablex.Parser.Expression.Comparison

  def expression do
    choice([
      parsec(:list),
      any(),
      range(),
      numeric(),
      bool(),
      null(),
      comparison(),
      quoted_string(),
      implied_string()
    ])
  end
end
