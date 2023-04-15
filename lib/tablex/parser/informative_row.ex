defmodule Tablex.Parser.InformativeRow do
  import NimbleParsec
  import Tablex.Parser.Space
  import Tablex.Parser.Variable

  def informative_row do
    space()
    |> times(
      concat(
        info(),
        space()
      )
      |> tag(:input),
      min: 0
    )
    |> concat(string("||") |> ignore())
    |> times(concat(space(), info()) |> tag(:output), min: 1)
    |> reduce({__MODULE__, :trans_info_row, []})
  end

  def info do
    choice([
      type(),
      string("-")
    ])
  end

  @doc false
  def trans_info_row(parsed) do
    [
      Keyword.get_values(parsed, :input) |> Enum.map(&trans_type/1),
      Keyword.get_values(parsed, :output) |> Enum.map(&trans_type/1)
    ]
  end

  defp trans_type(["-"]), do: {:undefined, nil}
  defp trans_type([type]), do: trans_type([type, nil])
  defp trans_type([type, desc]), do: {type, desc}
end
