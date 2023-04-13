defmodule Tablex do
  @moduledoc """
  Tablex implements Decision Table. It's goal is to make domain rules easy to maintain.
  """

  defdelegate decide(table, args), to: Tablex.Decider
  defdelegate decide(table, args, opts), to: Tablex.Decider

  def new(content, opts \\ []) do
    Tablex.Parser.parse(content, opts)
  end

  def sigil_RULES(content, opts) do
    new(content, opts)
  end
end
