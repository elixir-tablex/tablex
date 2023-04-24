defmodule Tablex.Parser.Expression.Any do
  @moduledoc false

  import NimbleParsec
  import Tablex.Parser.Space

  def any do
    "-"
    |> string()
    |> lookahead(eow())
    |> replace(:any)
  end
end
