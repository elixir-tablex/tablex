defmodule Tablex.Optimizer.RemoveDuplication do
  @moduledoc """
  This module is responsible for optimizing a table by removing duplicated rules.
  """

  alias Tablex.Table

  import Tablex.Optimizer.Helper,
    only: [
      order_by_priority: 3,
      sort_rules: 2,
      fix_ids: 1
    ]

  def optimize(%Table{} = table) do
    remove_duplicated_rules(table)
  end

  defp remove_duplicated_rules(table) do
    Map.update!(table, :rules, &remove_duplicated_rules(&1, table.hit_policy))
  end

  defp remove_duplicated_rules(rules, :collect),
    do: rules

  defp remove_duplicated_rules(rules, hit_policy) do
    rules
    |> order_by_priority(:h2l, hit_policy)
    |> do_remove_same_rules({MapSet.new(), []})
    |> sort_rules(hit_policy)
    |> fix_ids()
  end

  defp do_remove_same_rules([], {_, acc}) do
    acc
  end

  defp do_remove_same_rules([[_id | key] = rule | rest], {set, acc}) do
    if MapSet.member?(set, key) do
      do_remove_same_rules(rest, {set, acc})
    else
      do_remove_same_rules(rest, {MapSet.put(set, key), [rule | acc]})
    end
  end
end
