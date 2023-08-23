defmodule Tablex.Optimizer.RemoveDeadRules do
  @moduledoc """
  This module is responsible for optimizing a table by removing dead rules.
  """

  alias Tablex.Table

  import Tablex.Optimizer.Helper,
    only: [
      order_by_priority: 3,
      cover_input?: 2,
      cover_output?: 2,
      sort_rules: 2
    ]

  def optimize(%Table{} = table) do
    remove_dead_rules(table)
  end

  defp remove_dead_rules(%Table{hit_policy: hit_policy} = table)
       when hit_policy in [:first_hit, :merge, :reverse_merge] do
    Map.update!(table, :rules, &remove_dead_rules(&1, hit_policy))
  end

  defp remove_dead_rules(%Table{} = table),
    do: table

  defp remove_dead_rules(rules, hit_policy) do
    rules = rules |> order_by_priority(:h2l, hit_policy)

    rules
    |> Enum.reduce([], fn low_rule, acc ->
      covered? =
        Enum.any?(acc, fn high_rule ->
          fully_covers?(high_rule, low_rule, hit_policy)
        end)

      if covered? do
        acc
      else
        [low_rule | acc]
      end
    end)
    |> sort_rules(hit_policy)
  end

  defp fully_covers?([_, {:input, input1} | _], [_, {:input, input2} | _], :first_hit) do
    cover_input?(input1, input2)
  end

  defp fully_covers?(
         [_, {:input, input1}, {:output, output1}],
         [_, {:input, input2}, {:output, output2}],
         _
       ) do
    cover_input?(input1, input2) and cover_output?(output1, output2)
  end
end
