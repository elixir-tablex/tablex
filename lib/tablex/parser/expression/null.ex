defmodule Tablex.Parser.Expression.Null do
  @moduledoc false

  import NimbleParsec

  def null do
    string("null") |> replace(nil)
  end
end
