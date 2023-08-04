defmodule Tablex.Optimizer.RemoveDeadRules do
  @moduledoc """
  This module is responsible for optimizing a table by removing dead rules.
  """

  alias Tablex.Table

  import Tablex.Optimizer.Helper,
    only: [
      order_by_priority_high_to_lower: 2,
      order_by_hit_policy: 3,
      covers?: 2
    ]

  def optimize(%Table{} = table) do
    remove_dead_rules(table)
  end

  defp remove_dead_rules(%Table{hit_policy: :collect} = table),
    do: table

  defp remove_dead_rules(%Table{hit_policy: hit_policy} = table) do
    Map.update!(table, :rules, &remove_dead_rules(&1, hit_policy))
  end

  defp remove_dead_rules(rules, hit_policy) do
    rules = rules |> order_by_priority_high_to_lower(hit_policy)

    rules
    |> Enum.reduce([], fn [_, {:input, input} | _] = rule, acc ->
      covered? =
        Enum.any?(acc, fn [_, {:input, input2} | _] ->
          covers?(input2, input)
        end)

      if covered? do
        acc
      else
        [rule | acc]
      end
    end)
    |> order_by_hit_policy(:l2h, hit_policy)
  end
end
