defmodule Tablex.Optimizer.RemoveDeadRules do
  @moduledoc """
  This module is responsible for optimizing a table by removing dead rules.
  """

  alias Tablex.Table

  import Tablex.Optimizer.Helper,
    only: [
      order_by_priority_high_to_lower: 2,
      order_by_hit_policy: 3
    ]

  def optimize(%Table{} = table) do
    remove_dead_rules(table)
  end

  defp remove_dead_rules(%Table{hit_policy: :first_hit} = table) do
    Map.update!(table, :rules, &remove_dead_rules(&1, table.hit_policy))
  end

  defp remove_dead_rules(table),
    do: table

  defp remove_dead_rules(rules, hit_policy) do
    rules = rules |> order_by_priority_high_to_lower(hit_policy)

    rules
    |> Enum.reduce([], fn [_, {:input, input} | _] = rule, acc ->
      if Enum.any?(acc, &covered?(&1, input)) do
        acc
      else
        [rule | acc]
      end
    end)
    |> order_by_hit_policy(:l2h, hit_policy)
  end

  defp covered?([_id, {:input, input} | _], input) do
    true
  end

  defp covered?([_id, {:input, existing_input} | _], input) do
    Stream.zip(existing_input, input)
    |> Enum.all?(fn {existing, new} -> covered?(existing, new) end)
  end

  defp covered?(:any, _), do: true
  defp covered?(same, same), do: true

  defp covered?({:>, n}, {cmp, m})
       when is_number(n) and is_number(m) and n < m and cmp in [:>, :>=],
       do: true

  defp covered?({:>=, n}, {cmp, m})
       when is_number(n) and is_number(m) and n <= m and cmp in [:>=, :>],
       do: true

  defp covered?({:<, n}, {cmp, m})
       when is_number(n) and is_number(m) and n > m and cmp in [:<, :<=],
       do: true

  defp covered?({:<=, n}, {cmp, m})
       when is_number(n) and is_number(m) and n >= m and cmp in [:<, :<=],
       do: true

  defp covered?(expr, list) when is_list(list),
    do: Enum.all?(list, &covered?(expr, &1))

  defp covered?(list, item) when is_list(list),
    do: Enum.any?(list, &covered?(&1, item))

  defp covered?(_, _),
    do: false
end
