defmodule Tablex.Parser.Expression do
  @moduledoc false

  import NimbleParsec
  import Tablex.Parser.Quoted
  import Tablex.Parser.Space

  def expression do
    choice([
      list(),
      any(),
      range(),
      numeric(),
      bool(),
      null(),
      quoted_string(),
      comparation(),
      implied_string()
    ])
  end

  def numeric do
    choice([
      float(),
      int()
    ])
    |> reduce({__MODULE__, :trans_numeric, []})
  end

  @doc false
  def trans_numeric(["-", n]), do: -n
  def trans_numeric([n]), do: n

  @doc false
  def trans_underscore_int(parts) do
    parts |> Enum.join() |> String.to_integer()
  end

  def int do
    optional(string("-"))
    |> choice([
      underscore_int(),
      integer(min: 1)
    ])
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

  def bool do
    choice([
      true_exp(),
      false_exp()
    ])
  end

  def true_exp do
    choice([
      string("Y"),
      string("T"),
      string("YES"),
      string("yes"),
      string("true")
    ])
    |> lookahead(eow())
    |> replace(true)
  end

  def false_exp do
    choice([
      string("N"),
      string("F"),
      string("NO"),
      string("no"),
      string("false")
    ])
    |> lookahead(eow())
    |> replace(false)
  end

  def null do
    string("null") |> replace(nil)
  end

  def any do
    edges = [string(" "), newline(), eos()]

    "-"
    |> string()
    |> lookahead(choice(edges))
    |> replace(:any)
  end

  def list do
    elem =
      choice([
        range(),
        comparation(),
        numeric(),
        bool(),
        null(),
        quoted_string(),
        implied_string()
      ])

    concat(
      elem,
      times(
        concat(
          "," |> string() |> optional_space() |> ignore(),
          elem
        ),
        min: 1
      )
    )
    |> wrap()
  end

  def comparation do
    choice([
      string(">="),
      string(">"),
      string("<="),
      string("<")
    ])
    |> optional_space()
    |> concat(numeric())
    |> reduce({__MODULE__, :trans_comparation, []})
  end

  @doc false
  def trans_comparation([op, num]) do
    {:"#{op}", num}
  end

  def range do
    int()
    |> string("..")
    |> concat(int())
    |> reduce({__MODULE__, :trans_range, []})
  end

  def trans_range([first, "..", last]) do
    first..last
  end

  def implied_string do
    utf8_string([not: 0..32, not: ?,], min: 1)
  end
end
