defmodule Tablex.Parser.Expression.ImpliedString do
  @moduledoc false

  import NimbleParsec

  def implied_string do
    utf8_string([not: 0..32, not: ?,, not: ?], not: ?[], min: 1)
  end
end
