defmodule Tablex.Rules do
  @moduledoc """
  High level rule APIs for Tablex.

  With rule APIs, one can:

  - find rules by a given set of inputs,
  - update an existing rule,
  - or create a new rule.
  """

  alias Tablex.Parser
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

  Nested inputs are supported.

    iex> table = Tablex.new(\"""
    ...>   F  foo.value  || color
    ...>   1  >90        || red
    ...>   2  80..90     || orange
    ...>   3  20..79     || green
    ...>   4  <20        || blue
    ...>   \""")
    ...> Tablex.Rules.get_rules(table, %{foo: %{value: 80}})
    [%Tablex.Rules.Rule{id: 2, inputs: [{[:foo, :value], 80..90}], outputs: [{[:color], "orange"}]}]

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

  @type updates() :: [update()]
  @type update() :: {:input, [any()] | map()} | {:output, [any()] | map()}

  @doc """
  Update an existing rule.

  ## Example

  A basic example of updating a rule:

    iex> table = Tablex.new(\"""
    ...>   F  value  || color
    ...>   1  -      || red
    ...>   \""")
    ...> table = Tablex.Rules.update_rule(table, 1, input: [80..90], output: ["orange"])
    ...> table.rules
    [[1, input: [80..90], output: ["orange"]]]

  You can also updte a rule with changes in a map format:

    iex> table = Tablex.new(\"""
    ...>   F  value  || color
    ...>   1  -      || red
    ...>   \""")
    ...> table = Tablex.Rules.update_rule(table, 1, input: %{value: 80..90}, output: %{color: "orange"})
    ...> table.rules
    [[1, input: [80..90], output: ["orange"]]]

  You can only update input values:

    iex> table = Tablex.new(\"""
    ...>   F  value  || color
    ...>   1  -      || red
    ...>   \""")
    ...> table = Tablex.Rules.update_rule(table, 1, input: %{value: 80..90})
    ...> table.rules
    [[1, input: [80..90], output: ["red"]]]

  You can only update output values:

    iex> table = Tablex.new(\"""
    ...>   F  value  || color
    ...>   1  -      || red
    ...>   \""")
    ...> table = Tablex.Rules.update_rule(table, 1, output: %{color: "orange"})
    ...> table.rules
    [[1, input: [:any], output: ["orange"]]]

  For updating nested input or output values, both nested map or direct values are supported:

    iex> table = Tablex.new(\"""
    ...>   F  target.value  || color
    ...>   1  -             || red
    ...>   \""")
    ...> table = Tablex.Rules.update_rule(table, 1, input: %{target: %{value: 80..90}}, output: %{color: "orange"})
    ...> table.rules
    [[1, input: [80..90], output: ["orange"]]]

    iex> table = Tablex.new(\"""
    ...>   F  target.value  || color
    ...>   1  -             || red
    ...>   \""")
    ...> table = Tablex.Rules.update_rule(table, 1, input: [80..90], output: ["orange"])
    ...> table.rules
    [[1, input: [80..90], output: ["orange"]]]
  """
  @spec update_rule(table(), integer(), updates()) :: table()
  def update_rule(%Table{} = table, id, updates) do
    update_input = Keyword.get(updates, :input) |> to_updater(table.inputs)
    update_output = Keyword.get(updates, :output) |> to_updater(table.outputs)

    table
    |> Map.update!(:rules, fn
      rules ->
        Enum.map(rules, fn
          [^id, {:input, input}, {:output, output}] ->
            [id, {:input, update_input.(input)}, {:output, update_output.(output)}]

          otherwise ->
            otherwise
        end)
    end)
  end

  defp to_updater(%{} = update, defs) do
    defs
    |> Stream.with_index()
    |> Stream.map(fn {%Tablex.Variable{name: name, path: path}, index} ->
      full_path = path ++ [name]

      case at_path(update, full_path) do
        nil ->
          & &1

        value ->
          &List.replace_at(&1, index, value)
      end
    end)
    |> Enum.reduce(& &1, fn f, acc ->
      fn update -> acc.(update) |> f.() end
    end)
  end

  defp to_updater(nil, _) do
    & &1
  end

  defp to_updater(new_value, _) do
    fn _ -> new_value end
  end

  defp at_path(%{} = map, path) do
    Enum.reduce_while(path, map, fn
      seg, acc ->
        case acc do
          %{^seg => value} ->
            {:cont, value}

          _ ->
            {:halt, nil}
        end
    end)
  end

  @doc """
  Update an existing rule by input.
  """
  @spec update_rule_by_input(table(), map(), map()) :: table()
  def update_rule_by_input(table, input, output_updates) do
    rule = find_rule_by_input(table, input)

    case rule do
      [id | _] ->
        update_rule(table, id, output: output_updates)

      nil ->
        add_new_rule_high_priority(table, input, output_updates)
    end
  end

  defp find_rule_by_input(table, input) do
    input = to_expected_values(input, table.inputs)

    table.rules
    |> Enum.find(&match?([_id, {:input, ^input} | _], &1))
  end

  defp to_expected_values(input, defs) do
    for %{path: path, name: name} <- defs, do: get_expr(input, path, name) |> parse_expression()
  end

  defp get_expr(input, path, name) do
    path = Enum.map(path, &Access.key(&1, %{}))
    any = "-"
    get_in(input, path ++ [Access.key(name, any)])
  end

  defp add_new_rule_high_priority(table, input, output_updates) do
    input = to_expected_values(input, table.inputs)
    output = to_expected_values(output_updates, table.outputs)
    new_rule = [1, {:input, input}, {:output, output}]

    table
    |> Map.update!(:rules, fn rules ->
      case table.hit_policy do
        :reverse_merge ->
          rules ++ [new_rule]

        _ ->
          [new_rule | rules]
      end
    end)
    |> update_ids()
  end

  defp parse_expression(expr) when is_binary(expr) do
    {:ok, [parsed], _, _, _, _} = Parser.expr(expr)
    parsed
  end

  defp parse_expression(expr), do: expr

  defp update_ids(%Table{} = table) do
    table
    |> Map.update!(:rules, fn rules ->
      rules
      |> Stream.with_index(1)
      |> Enum.map(fn {[_ | content], index} ->
        [index | content]
      end)
    end)
  end
end
