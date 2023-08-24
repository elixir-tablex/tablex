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
      merge_outputs: 2,
      merge_inputs: 2,
      input_mergeable?: 2,
      exclusive?: 2,
      order_by_priority_high_to_lower: 2,
      sort_rules: 2
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
    %{
      table
      | rules:
          rules
          |> order_by_priority_high_to_lower(@hp_merge)
          |> do_merge_rules_by_same_input()
    }
  end

  defp merge_rules_by_same_input(%Table{rules: rules, hit_policy: @hp_reverse_merge} = table) do
    %{
      table
      | rules:
          rules
          |> order_by_priority_high_to_lower(@hp_reverse_merge)
          |> do_merge_rules_by_same_input()
          |> sort_rules(@hp_reverse_merge)
    }
  end

  defp merge_rules_by_same_input(%Table{} = table) do
    table
  end

  defp do_merge_rules_by_same_input(rules) when is_list(rules) do
    do_merge_rules_by_same_input(rules, [])
  end

  defp do_merge_rules_by_same_input([], merged) do
    merged
  end

  defp do_merge_rules_by_same_input([rule | rest], merged) do
    do_merge_rules_by_same_input(rest, try_merge_input(rule, merged))
    |> Enum.reverse()
  end

  defp try_merge_input(rule, []) do
    [rule]
  end

  defp try_merge_input(
         [n, {:input, input}, {:output, low_output}],
         [[_, {:input, input}, {:output, high_output}] | rest]
       ) do
    [[n, {:input, input}, {:output, merge_outputs(high_output, low_output)}] | rest]
  end

  defp try_merge_input(rule, [head | rest]) do
    if exclusive?(head, rule),
      do: [head | try_merge_input(rule, rest)],
      else: [rule, head | rest]
  end

  defp merge_rules_by_same_output(%Table{rules: rules, hit_policy: hp} = table)
       when hp in [@hp_first_hit, @hp_merge, @hp_reverse_merge] do
    rules =
      rules
      |> order_by_priority_high_to_lower(hp)
      |> do_merge_rules_by_same_output()
      |> sort_rules(hp)

    %{table | rules: rules}
  end

  defp merge_rules_by_same_output(%Table{} = table),
    do: table

  defp do_merge_rules_by_same_output(rules) when is_list(rules) do
    merged = do_merge_rules_by_same_output(rules, [])

    case do_merge_rules_by_same_output(merged, []) do
      ^merged -> merged
      acc -> do_merge_rules_by_same_output(acc, [])
    end
  end

  defp do_merge_rules_by_same_output([], acc), do: acc

  defp do_merge_rules_by_same_output([rule | rest], acc) do
    do_merge_rules_by_same_output(rest, try_merge_output(rule, acc))
  end

  defp try_merge_output(rule, []) do
    [rule]
  end

  defp try_merge_output(
         [n, {:input, low_input}, {:output, same_output}] = r1,
         [[_, {:input, high_input}, {:output, same_output}] = r2 | rest]
       ) do
    cond do
      input_mergeable?(low_input, high_input) ->
        [
          [n, {:input, merge_inputs(low_input, high_input)}, {:output, same_output}]
          | rest
        ]

      exclusive?(r1, r2) ->
        [r2 | try_merge_output(r1, rest)]

      :otherwise ->
        [r2, r1 | rest]
    end
  end

  defp try_merge_output(rule, [head | rest]) do
    if exclusive?(head, rule),
      do: [head | try_merge_output(rule, rest)],
      else: [rule, head | rest]
  end
end
