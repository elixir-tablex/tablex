defmodule Tablex.Parser.Expression.Integer do
  @moduledoc false

  import NimbleParsec

  def int do
    optional(string("-"))
    |> choice([
      underscore_int(),
      integer(min: 1)
    ])
    |> reduce({__MODULE__, :trans_numeric, []})
  end

  def underscore_int do
    ascii_string([?0..?9], min: 1)
    |> times(
      string("_")
      |> ignore()
      |> ascii_string([?0..?9], min: 1),
      min: 1
    )
    |> reduce({__MODULE__, :trans_underscore_int, []})
  end

  @doc false
  def trans_underscore_int(parts) do
    parts |> Enum.join() |> String.to_integer()
  end

  @doc false
  def trans_numeric(["-", n]), do: -n
  def trans_numeric([n]), do: n
end
