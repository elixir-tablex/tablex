defmodule Tablex.Rules do
  @moduledoc """
  High level rule APIs for Tablex.

  With rule APIs, one can:

  - find rules by a given set of inputs,
  - update an existing rule,
  - or create a new rule.
  """

  alias Tablex.Table

  @type table :: Table.t()
  @type rule :: Table.rule()

  @doc """
  Find rules by a given set of inputs.

  ## Parameters

    - `table`: the table to find rules for
    - `args`: the set of inputs to find rules for

  ## Returns

  A list of rules matching the given set of inputs.
  The ordering of the list follows the priority of the rules,
  with the lower-priority rule taking more precedence.

  ## Example

    iex> table = Tablex.new(\"""
    ...>   F  value  || color
    ...>   1  >90    || red
    ...>   2  80..90 || orange
    ...>   3  20..79 || green
    ...>   4  <20    || blue
    ...>   \""")
    ...> Tablex.Rules.get_rules(table, %{})
    []
    ...> Tablex.Rules.get_rules(table, %{value: 80})
    [%Tablex.Rules.Rule{id: 2, inputs: [{[:value], 80..90}], outputs: [{[:color], "orange"}]}]

  This example shows how the returned rules are ordered by priority:

    iex> table = Tablex.new(\"""
    ...>   M  country state || feature_enabled
    ...>   1  US      CA    || true
    ...>   2  US      -     || false
    ...>   3  CA      -     || true
    ...>   \""")
    ...> Tablex.Rules.get_rules(table, %{country: "US", state: "CA"})
    [
      %Tablex.Rules.Rule{id: 2, inputs: [{[:country], "US"}, {[:state], :any}], outputs: [{[:feature_enabled], false}]},
      %Tablex.Rules.Rule{id: 1, inputs: [{[:country], "US"}, {[:state], "CA"}], outputs: [{[:feature_enabled], true}]}
    ]
  """
  @spec get_rules(table(), keyword()) :: [rule()]
  def get_rules(%Table{} = table, args) do
    context = build_context(table.inputs, args)

    table.rules
    |> Stream.map(&to_rule_struct(&1, table))
    |> Stream.filter(&match_rule?(&1, context))
    |> order_by_priority(table.hit_policy)
  end

  defp build_context(inputs, args) do
    inputs
    |> Stream.map(&value_path/1)
    |> Enum.map(&get_in(args, &1))
  end

  defp value_path(%Tablex.Variable{name: name, path: path}) do
    path ++ [name]
  end

  defp to_rule_struct([id, {:input, inputs}, {:output, output} | _], %{
         inputs: input_defs,
         outputs: output_defs
       }) do
    inputs =
      inputs
      |> Stream.zip(input_defs)
      |> Enum.map(fn {expect, df} ->
        {value_path(df), expect}
      end)

    outputs =
      output
      |> Stream.zip(output_defs)
      |> Enum.map(fn {value, od} ->
        {value_path(od), value}
      end)

    %Tablex.Rules.Rule{
      id: id,
      inputs: inputs,
      outputs: outputs
    }
  end

  defp match_rule?(rule, context) do
    Stream.zip(rule.inputs, context)
    |> Enum.all?(fn {{_path, expect}, value} ->
      match_expect?(expect, value)
    end)
  end

  @doc """
  Check if the given value matches the asserting expectation.
  """
  def match_expect?(expect, value) when is_list(expect) do
    Enum.any?(expect, &match_expect?(&1, value))
  end

  def match_expect?(%Range{first: first, last: last}, value) when is_number(value) do
    # we can't use `in` here because value may be a float.
    value >= first and value <= last
  end

  def match_expect?({:!=, x}, value) when value != x, do: true
  def match_expect?({:>, x}, value) when is_number(value) and value > x, do: true
  def match_expect?({:>=, x}, value) when is_number(value) and value >= x, do: true
  def match_expect?({:<, x}, value) when is_number(value) and value < x, do: true
  def match_expect?({:<=, x}, value) when is_number(value) and value <= x, do: true

  def match_expect?(:any, _), do: true
  def match_expect?(expect, expect), do: true
  def match_expect?(_, _), do: false

  defp order_by_priority(matched_rules, :reverse_merge) do
    Enum.sort_by(matched_rules, & &1.id)
  end

  defp order_by_priority(matched_rules, _hit_policy) do
    Enum.sort_by(matched_rules, & &1.id, :desc)
  end
end
