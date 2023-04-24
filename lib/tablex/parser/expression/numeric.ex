defmodule Tablex.Parser.Expression.Numeric do
  @moduledoc false

  import NimbleParsec
  import Tablex.Parser.Expression.Integer
  import Tablex.Parser.Expression.Float

  def numeric do
    choice([
      float(),
      int()
    ])
  end
end
