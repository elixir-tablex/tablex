defmodule Tablex do
  @moduledoc """
  Tablex implements Decision Table. Its goal is to make domain rules easy to maintain.
  """

  defdelegate decide(table, args), to: Tablex.Decider
  defdelegate decide(table, args, opts), to: Tablex.Decider

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
  @spec new(String.t(), keyword()) :: Tablex.Table.t()
  def new(content, opts \\ []) do
    Tablex.Parser.parse(content, opts)
  end

  @doc """
  Same as `new/2`.

  ## Example
      import Tablex

      ~t\"""
      F  value  || color
      1  >90    || red
      2  80..90 || orange
      3  20..79 || green
      4  <20    || blue
      \"""
  """
  @spec sigil_t(String.t(), keyword()) :: Tablex.Table.t()
  def sigil_t(content, opts) do
    new(content, opts)
  end
end
