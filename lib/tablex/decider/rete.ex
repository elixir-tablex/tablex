defmodule Tablex.Decider.Rete do
  @moduledoc """
  Decision engine module responsible for applying a set of rules to input data
  and returning the output according to the hit policy.
  """

  alias Tablex.Table

  @type options :: []

  @behaviour Tablex.DeciderBehaviour

  @doc """
  Run the decision process on the given table, arguments, and options.
  """
  @spec decide(Table.t(), keyword(), options()) :: map() | {:error, :hit_policy_not_implemented}
  def decide(table, args, opts \\ [])

  def decide(%Table{hit_policy: hit_policy} = table, args, _opts) do
    rules = encode_rules(table.rules, table.inputs, table.outputs)
    facts = Enum.map(args, &arg_to_fact/1)

    NeuralBridge.Session.new(inspect(table))
    |> NeuralBridge.Session.add_rules(rules)
    |> NeuralBridge.Session.add_facts(facts)
    |> Map.fetch!(:inferred_facts)
    |> collect_results(hit_policy)
  end

  def decide(%Table{}, _, _) do
    {:error, {__MODULE__, :hit_policy_not_implemented}}
  end

  def decide({:error, _} = err, _, _) do
    err
  end

  defp collect_results(facts, hit_policy) do
    case hit_policy do
      :first_hit ->
        facts |> Enum.reverse() |> Map.new(fn wme -> {wme.identifier, wme.value} end)

      :merge ->
        facts |> Map.new(fn wme -> {wme.identifier, wme.value} end)

      :reverse_merge ->
        facts |> Enum.reverse() |> Map.new(fn wme -> {wme.identifier, wme.value} end)

      :collect ->
        Enum.map(facts, fn wme -> {wme.identifier, wme.value} end)
    end
  end

  defp encode_rules(rules, inputs, outputs) do
    Enum.map(rules, fn rule ->
      [rule_id, {:input, given}, {:output, then}] = rule

      given =
        Enum.with_index(given, fn row, index ->
          attribute = Enum.at(inputs, index).name
          "#{attribute}'s #{attribute}_value #{parse_rule_check(attribute, row)}"
        end)
        |> Enum.join(" \n ")

      then =
        Enum.map(outputs, fn output ->
          Enum.flat_map(then, fn clause ->
            Enum.map(List.wrap(clause), fn clause ->
              "#{output.name}'s value #{parse_rule_then(clause)}"
            end)
          end)
        end)
        |> Enum.join(" \n ")

      NeuralBridge.Rule.new(id: rule_id, given: given, then: then)
    end)
  end

  defp arg_to_fact({key, value}) do
    Retex.Wme.new(to_string(key), "#{key}_value", value)
  end

  defp parse_rule_then(list) when is_list(list) do
    "is #{inspect(list)}"
  end

  defp parse_rule_then(value) when is_binary(value) or is_number(value) do
    "is #{inspect(value)}"
  end

  defp parse_rule_then(nil) do
    "is #{inspect(nil)}"
  end

  defp parse_rule_check(_attribute, list) when is_list(list) do
    "in #{inspect(list)}"
  end

  defp parse_rule_check(_, %{__struct__: Range, first: first, last: last} = range) do
    "in [#{Enum.map(range, fn n -> n end) |> Enum.join(",")}]"
  end

  defp parse_rule_check(_attribute, value) when is_binary(value) or is_number(value) do
    "is equal #{inspect(value)}"
  end

  defp parse_rule_check(_attribute, {:>, value}) do
    "is greater #{value}"
  end

  defp parse_rule_check(attribute, :any) do
    "is equal $#{attribute}"
  end
end
