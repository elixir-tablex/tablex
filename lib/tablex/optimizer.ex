defmodule Tablex.Optimizer do
  @moduledoc """
  This module is responsible for optimizing a table.

  Optimization is done by regrouping the rules of the table.
  After an optimization, duplicated rules are removed, and
  similar rules are merged.
  """

  alias Tablex.Table
  alias Tablex.Optimizer.RemoveDuplication
  alias Tablex.Optimizer.RemoveDeadRules
  alias Tablex.Optimizer.RemoveEmptyRules
  alias Tablex.Optimizer.MergeRules

  @doc """
  Optimize a table.
  """
  @spec optimize(Table.t()) :: Table.t()
  def optimize(%Table{} = table) do
    table
    |> RemoveDuplication.optimize()
    |> RemoveDeadRules.optimize()
    |> RemoveEmptyRules.optimize()
    |> MergeRules.optimize()
  end
end
