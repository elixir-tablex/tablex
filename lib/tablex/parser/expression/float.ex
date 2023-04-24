defmodule Tablex.Parser.Expression.Float do
  @moduledoc false

  import NimbleParsec

  def float do
    optional(string("-"))
    |> ascii_string([?0..?9], min: 1)
    |> string(".")
    |> ascii_string([?0..?9], min: 1)
    |> reduce({__MODULE__, :trans_float, []})
  end

  @doc false
  def trans_float(parts) do
    parts |> Enum.join() |> String.to_float()
  end
end
