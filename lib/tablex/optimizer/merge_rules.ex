defmodule Tablex.Optimizer.MergeRules do
  @moduledoc """
  This module is responsible for optimizing a table by removing dead rules.
  """

  alias Tablex.Table
  import Tablex.Optimizer.Helper, only: [fix_ids: 1]

  def optimize(%Table{} = table) do
    merge_rules(table)
  end

  defp merge_rules(%Table{rules: rules, hit_policy: :merge} = table) do
    %{table | rules: do_merge_rules(rules) |> fix_ids()}
  end

  defp merge_rules(%Table{rules: rules, hit_policy: :reverse_merge} = table) do
    %{table | rules: rules |> Enum.reverse() |> do_merge_rules() |> Enum.reverse() |> fix_ids()}
  end

  defp merge_rules(%Table{} = table),
    do: table

  defp do_merge_rules(rules) when is_list(rules) do
    do_merge_rules(rules, [])
  end

  defp do_merge_rules([], acc), do: acc

  defp do_merge_rules([rule | rest], acc) do
    do_merge_rules(rest, try_merge_in(acc, rule))
  end

  defp try_merge_in([], rule) do
    [rule]
  end

  defp try_merge_in([head | tail], rule) do
    cond do
      mergeable?(head, rule) ->
        [merge_two_rules(head, rule) | tail]

      :otherwise ->
        [head | try_merge_in(tail, rule)]
    end
  end

  @doc """
  Return true if rule2 can be merged into rule1
  """
  def mergeable?(
        [_, {:input, input1}, {:output, output}],
        [_, {:input, input2}, {:output, output}]
      ),
      do: input_mergeable?(input1, input2)

  def mergeable?(_, _), do: false

  defp input_mergeable?(input1, input2) do
    diff =
      Stream.zip(input1, input2)
      |> Stream.reject(fn
        {same, same} -> true
        _ -> false
      end)
      |> Enum.count()

    diff == 1
  end

  defp merge_two_rules(
         [id, {:input, input1}, {:output, output}],
         [_i, {:input, input2}, {:output, output}]
       ) do
    [id, {:input, merge_input_stubs(input1, input2)}, {:output, output}]
  end

  defp merge_input_stubs(input1, input2) do
    Stream.zip(input1, input2)
    |> Enum.map(fn
      {expr, expr} -> expr
      {expr1, expr2} -> List.flatten([expr1, expr2]) |> Enum.sort()
    end)
  end
end
