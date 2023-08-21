defmodule Tablex.Parser.Expression.List do
  @moduledoc false

  defmacro __using__(_) do
    quote do
      import NimbleParsec
      import Tablex.Parser.Expression.Range
      import Tablex.Parser.Expression.Numeric
      import Tablex.Parser.Expression.Bool
      import Tablex.Parser.Expression.Comparison
      import Tablex.Parser.Expression.QuotedString
      import Tablex.Parser.Expression.ImpliedString
      import Tablex.Parser.Expression.Null
      import Tablex.Parser.Space

      defparsec(
        :explicit_list,
        string("[")
        |> concat(
          concat(
            parsec(:list_item),
            repeat(
              concat(
                "," |> string() |> optional_space() |> ignore(),
                parsec(:list_item)
              )
            )
          )
          |> wrap()
        )
        |> string("]")
        |> reduce({unquote(__MODULE__), :trans_list, []})
      )

      defparsec(
        :implied_list,
        concat(
          parsec(:list_item),
          times(
            concat(
              "," |> string() |> optional_space() |> ignore(),
              parsec(:list_item)
            ),
            min: 1
          )
        )
        |> wrap()
      )

      defparsec(
        :list_item,
        choice([
          parsec(:explicit_list),
          range(),
          comparison(),
          numeric(),
          bool(),
          null(),
          quoted_string(),
          implied_string()
        ])
      )

      defparsec(
        :list,
        choice([
          parsec(:empty_list),
          parsec(:explicit_list),
          parsec(:implied_list)
        ])
      )

      defparsec(
        :empty_list,
        string("[]") |> replace([])
      )
    end
  end

  @doc false
  def trans_list(["[", passed, "]"]), do: passed
end
