defmodule Tablex.Parser.Expression.Range do
  @moduledoc false

  import NimbleParsec
  import Tablex.Parser.Expression.Integer

  def range do
    int()
    |> string("..")
    |> concat(int())
    |> reduce({__MODULE__, :trans_range, []})
  end

  def trans_range([first, "..", last]) do
    first..last
  end
end
