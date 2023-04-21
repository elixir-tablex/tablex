defmodule Tablex.Parser.Code do
  @moduledoc false

  import NimbleParsec

  @doc """
  Parse a code
  """
  def code do
    ascii_char([?`])
    |> ignore()
    |> repeat_while(
      choice([
        ~S(\`) |> string() |> replace(?`),
        utf8_char([])
      ]),
      {__MODULE__, :not_end, []}
    )
    |> ignore(ascii_char([?`]))
    |> reduce({List, :to_string, []})
    |> unwrap_and_tag(:code)
  end

  @doc false
  def not_end(<<?`, _::binary>>, context, _, _) do
    {:halt, context}
  end

  def not_end(_, context, _, _) do
    {:cont, context}
  end
end
