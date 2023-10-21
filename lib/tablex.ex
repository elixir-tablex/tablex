defmodule Tablex do
  @moduledoc """
  Tablex implements Decision Table. Its goal is to make domain rules easy to maintain.
  """

  def decide(table, args, opts \\ []) do
    Tablex.Decider.Naive.decide(table, args, opts)
  end

  @doc """
  Create a new table.

  ## Example

      Tablex.new(\"""
        F  value  || color
        1  >90    || red
        2  80..90 || orange
        3  20..79 || green
        4  <20    || blue
        \""")
  """
  @spec new(String.t(), keyword()) :: Tablex.Table.t() | Tablex.Parser.parse_error()
  def new(content, opts \\ []) when is_binary(content) do
    content
    |> String.trim_trailing()
    |> Tablex.Parser.parse(opts)
  end

  if Version.compare(System.version(), "1.15.0-dev") in [:eq, :gt] do
    @doc """
    The same as `new/2`.

    ## Example

        ~RULES\"""
        F  value  || color
        1  >90    || red
        2  80..90 || orange
        3  20..79 || green
        4  <20    || blue
        \"""
    """
    @spec sigil_RULES(String.t(), keyword()) :: Tablex.Table.t()
    def sigil_RULES(content, opts) do
      new(content, opts)
    end
  end
end
