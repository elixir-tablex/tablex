defmodule Tablex.Formatter do
  @moduledoc """
  This module is responsible for turning a table into text.
  """
  alias Tablex.Table

  def to_s(%Table{table_dir: :h} = table) do
    Tablex.Formatter.Horizontal.to_s(table)
  end

  def to_s(%Table{table_dir: :v} = table) do
    Tablex.Formatter.Vertical.to_s(table)
  end
end
