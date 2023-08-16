defmodule Tablex.Optimizer.MergeRules do
  @moduledoc """
  This module is responsible for optimizing a table by removing dead rules.
  """

  alias Tablex.Table
  alias Tablex.Util.ListBreaker

  @hp_first_hit :first_hit
  @hp_merge :merge
  @hp_reverse_merge :reverse_merge

  import Tablex.Optimizer.Helper,
    only: [
      fix_ids: 1,
      conflict_free_output: 2,
      meaningful_output?: 1
    ]

  def optimize(%Table{} = table) do
    table
    |> break_list_rules()
    |> merge_rules_by_same_input()
    |> merge_rules_by_same_output()
    |> Map.update!(:rules, &fix_ids/1)
  end

  defp break_list_rules(%Table{rules: rules} = table) do
    rules =
      rules
      |> Enum.flat_map(fn [i, {:input, input}, {:output, output}] ->
        input
        |> ListBreaker.flatten_list()
        |> Enum.map(&[i, {:input, &1}, {:output, output}])
      end)

    %{table | rules: rules}
  end

  # if two rules have the same input, the rule with lower priority would be examined
  # to have only stubs that are not covered by the other rule. If all stubs after
  # the examination of the lower priority rule are covered by the other rule, then
  # the lower priority rule is removed directly.
  defp merge_rules_by_same_input(%Table{rules: rules, hit_policy: @hp_merge} = table) do
    # For tables with `:merge` hit policy, the higher priority the rule has, the
    # higher the prosition it is.
    %{table | rules: do_merge_rules_by_same_input(rules)}
  end

  defp merge_rules_by_same_input(%Table{rules: rules, hit_policy: @hp_reverse_merge} = table) do
    %{
      table
      | rules:
          rules
          |> Enum.reverse()
          |> do_merge_rules_by_same_input()
          |> Enum.reverse()
    }
  end

  defp merge_rules_by_same_input(%Table{} = table) do
    table
  end

  defp do_merge_rules_by_same_input(rules) when is_list(rules) do
    do_merge_rules_by_same_input(rules, [])
    |> Stream.filter(fn [_, _, {:output, output}] ->
      meaningful_output?(output)
    end)
    |> Enum.reverse()
  end

  defp do_merge_rules_by_same_input([], acc), do: acc

  defp do_merge_rules_by_same_input([head | rest], higher_priority_rules) do
    do_merge_rules_by_same_input(rest, [
      try_merge_output_in(higher_priority_rules, head) | higher_priority_rules
    ])
  end

  defp try_merge_output_in(higher_priority_rules, rule) do
    Enum.reduce(higher_priority_rules, rule, fn
      [_, {:input, input}, {:output, hp_output}], [id, {:input, input}, {:output, output}] ->
        [id, {:input, input}, {:output, conflict_free_output(output, hp_output)}]

      _, acc ->
        acc
    end)
  end

  defp merge_rules_by_same_output(%Table{rules: rules, hit_policy: hp} = table)
       when hp in [@hp_first_hit, @hp_merge] do
    %{table | rules: do_merge_rules_by_same_output(rules)}
  end

  defp merge_rules_by_same_output(%Table{rules: rules, hit_policy: @hp_reverse_merge} = table) do
    %{
      table
      | rules:
          rules
          |> Enum.reverse()
          |> do_merge_rules_by_same_output()
          |> Enum.reverse()
    }
  end

  defp merge_rules_by_same_output(%Table{} = table),
    do: table

  defp do_merge_rules_by_same_output(rules) when is_list(rules) do
    merged = do_merge_rules_by_same_output(rules, [])

    case do_merge_rules_by_same_output(merged, []) do
      ^merged -> merged
      acc -> do_merge_rules_by_same_output(acc)
    end
  end

  defp do_merge_rules_by_same_output([], acc), do: acc

  defp do_merge_rules_by_same_output([rule | rest], acc) do
    do_merge_rules_by_same_output(rest, try_merge_inputs_by_same_output(acc, rule))
  end

  defp try_merge_inputs_by_same_output([], rule) do
    [rule]
  end

  defp try_merge_inputs_by_same_output([head | tail], rule) do
    cond do
      input_mergeable?(head, rule) ->
        merge_inputs(head, rule) ++ tail

      :otherwise ->
        [head | try_merge_inputs_by_same_output(tail, rule)]
    end
  end

  @doc """
  Return true if rule2's inputs can be merged into rule1's.
  """
  def input_mergeable?(
        [_, {:input, input1}, {:output, output}],
        [_, {:input, input2}, {:output, output}]
      ),
      do: only_one_different_stub?(input1, input2)

  def input_mergeable?(_, _), do: false

  defp only_one_different_stub?(input1, input2) do
    diff =
      Stream.zip(input1, input2)
      |> Stream.reject(fn
        {same, same} -> true
        _ -> false
      end)
      |> Enum.count()

    diff == 1
  end

  defp merge_inputs(
         [id, {:input, input1}, {:output, output}],
         [_i, {:input, input2}, {:output, output}]
       ) do
    [[id, {:input, merge_input_stubs(input1, input2)}, {:output, output}]]
  end

  defp merge_input_stubs(input1, input2) do
    Stream.zip(input1, input2)
    |> Enum.map(fn
      {expr, expr} -> expr
      {expr1, expr2} -> List.flatten([expr1, expr2]) |> Enum.sort()
    end)
  end
end
