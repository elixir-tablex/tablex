defmodule Tablex.Parser.Rule do
  @moduledoc false

  import NimbleParsec
  import Tablex.Parser.Expression
  import Tablex.Parser.Space

  def rules(combinitor \\ empty()) do
    concat(
      combinitor,
      rule()
      |> concat(
        concat(
          newline(),
          rule()
        )
        |> times(min: 1)
        |> optional()
      )
      |> tag(:rules)
    )
    |> ignore(
      choice([
        newline(),
        eos()
      ])
    )
  end

  def rule do
    integer(min: 1)
    |> space()
    |> repeat_while(
      concat(expression(), space()),
      {__MODULE__, :not_seperator, []}
    )
    |> concat(seperator())
    |> space()
    |> concat(
      expression()
      |> concat(
        times(
          concat(
            space(),
            expression()
          ),
          min: 0
        )
      )
    )
    |> optional_space()
    |> reduce({__MODULE__, :trans_rule, []})
  end

  @doc false
  def not_seperator(<<"|| ", _::binary>>, context, _, _),
    do: {:halt, context}

  def not_seperator(_rest, context, _, _),
    do: {:cont, context}

  def seperator do
    string("||") |> replace(:||)
  end

  @doc false
  def trans_rule(parts) do
    {[rn | inputs], [:|| | outputs]} = Enum.split_while(parts, &(&1 != :||))
    [rn, {:input, inputs}, {:output, outputs}]
  end
end
