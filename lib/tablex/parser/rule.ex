defmodule Tablex.Parser.Rule do
  @moduledoc false

  import NimbleParsec
  import Tablex.Parser.Code
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
      {__MODULE__, :not_separator, []}
    )
    |> concat(separator())
    |> space()
    |> concat(
      output_expression()
      |> concat(
        times(
          concat(
            space(),
            output_expression()
          ),
          min: 0
        )
      )
    )
    |> optional_space()
    |> reduce({__MODULE__, :trans_rule, []})
  end

  @doc false
  def not_separator(<<"|| ", _::binary>>, context, _, _),
    do: {:halt, context}

  def not_separator(_rest, context, _, _),
    do: {:cont, context}

  def separator do
    string("||") |> replace(:||)
  end

  def output_expression do
    choice([
      code(),
      expression()
    ])
  end

  @doc false
  def trans_rule(parts) do
    {[rn | inputs], [:|| | outputs]} = Enum.split_while(parts, &(&1 != :||))
    [rn, {:input, inputs}, {:output, outputs}]
  end
end
