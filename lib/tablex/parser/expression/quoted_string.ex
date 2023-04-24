defmodule Tablex.Parser.Expression.QuotedString do
  @moduledoc false

  import NimbleParsec

  @doc """
  Parse a quoted string.
  """
  def quoted_string do
    ascii_char([?"])
    |> ignore()
    |> repeat_while(
      choice([
        ~S(\") |> string() |> replace(?"),
        utf8_char([])
      ]),
      {__MODULE__, :not_quoted, []}
    )
    |> ignore(ascii_char([?"]))
    |> reduce({List, :to_string, []})
  end

  @doc false
  def not_quoted(<<?", _::binary>>, context, _, _) do
    {:halt, context}
  end

  def not_quoted(_, context, _, _) do
    {:cont, context}
  end
end
