defmodule Tablex.Parser.Expression.List do
  @moduledoc false

  import NimbleParsec
  import Tablex.Parser.Expression.Range
  import Tablex.Parser.Expression.Numeric
  import Tablex.Parser.Expression.Bool
  import Tablex.Parser.Expression.Comparation
  import Tablex.Parser.Expression.QuotedString
  import Tablex.Parser.Expression.ImpliedString
  import Tablex.Parser.Expression.Null
  import Tablex.Parser.Space

  def list do
    choice([
      empty_list(),
      explict_list(),
      implied_list()
    ])
  end

  def empty_list do
    string("[]") |> replace([])
  end

  def explict_list do
    string("[")
    |> concat(
      choice([
        implied_list(),
        list_item()
      ])
    )
    |> string("]")
    |> reduce({__MODULE__, :trans_list, []})
  end

  def implied_list do
    concat(
      list_item(),
      times(
        concat(
          "," |> string() |> optional_space() |> ignore(),
          list_item()
        ),
        min: 1
      )
    )
    |> wrap()
  end

  def list_item do
    choice([
      range(),
      comparation(),
      numeric(),
      bool(),
      null(),
      quoted_string(),
      implied_string()
    ])
  end

  @doc false
  def trans_list(["[", "]"]), do: []
  def trans_list(["[", pased, "]"]), do: List.wrap(pased)
end
