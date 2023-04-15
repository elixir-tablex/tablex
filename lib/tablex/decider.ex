defmodule Tablex.Decider do
  @moduledoc """
  Decision engine module responsible for applying a set of rules to input data
  and returning the output according to the hit policy.
  """

  alias Tablex.Table

  @type options :: []

  @doc """
  Run the decision process on the given table, arguments, and options.

  ## Examples

      iex> decide(table, args)
      output
  """
  @spec decide(Table.t(), keyword(), options()) :: map() | {:error, :hit_policy_not_implemented}
  def decide(table, args, opts \\ [])

  def decide(%Table{hit_policy: :first_hit} = table, args, _opts) do
    context = context(table.inputs, args)

    select(context, table)
  end

  def decide(%Table{hit_policy: :collect} = table, args, _opts) do
    context = context(table.inputs, args)

    collect(context, table)
  end

  def decide(%Table{hit_policy: :merge} = table, args, _opts) do
    context = context(table.inputs, args)

    merge(context, table)
  end

  def decide(%Table{hit_policy: :reverse_merge} = table, args, _opts) do
    context = context(table.inputs, args)

    reverse_merge(context, table)
  end

  def decide(%Table{}, _, _) do
    {:error, :hit_policy_not_implemented}
  end

  def decide({:error, _} = err, _, _) do
    err
  end

  defp context(inputs, args) do
    for %{name: name, path: path} <- inputs, into: %{} do
      path = path ++ [name]
      {path, get_in(args, path)}
    end
    |> flatten_path()
  end

  defp rules(%Table{rules: rules, inputs: inputs, outputs: outputs}) do
    rules
    |> Stream.map(fn [n, input: input_values, output: output_values] ->
      {n, condition(input_values, inputs), output(output_values, outputs)}
    end)
    |> Enum.sort_by(fn {n, _, _} -> n end)
    |> Enum.map(fn {_, condition, output} -> {condition, output} end)
  end

  defp condition(input_values, defs) do
    for {v, %{name: var, path: path}} <- Enum.zip(input_values, defs), into: %{} do
      {path ++ [var], v}
    end
  end

  defp output(output_values, defs) do
    for {v, %{name: var, path: path}} <- Enum.zip(output_values, defs), into: %{} do
      {path ++ [var], v}
    end
  end

  defp select(context, %Table{} = table) do
    rules = rules(table)

    hit =
      Enum.find(rules, fn {condition, _} ->
        match_rule?(condition, context)
      end)

    case hit do
      {_condition, output} ->
        flatten_path(output)

      nil ->
        nil
    end
  end

  defp collect(context, %Table{} = table) do
    table
    |> rules()
    |> Stream.filter(fn {condition, _} ->
      match_rule?(condition, context)
    end)
    |> Stream.map(fn {_condition, outputs} ->
      flatten_path(outputs)
    end)
    |> Enum.to_list()
  end

  defp merge(context, %Table{outputs: outputs} = table) do
    empty = for %{name: var, path: path} <- outputs, into: %{}, do: {path ++ [var], :undefined}

    table
    |> rules()
    |> Stream.filter(fn {condition, _} ->
      match_rule?(condition, context)
    end)
    |> Stream.map(fn {_condition, outputs} ->
      outputs
    end)
    |> Enum.reduce_while(empty, &merge_if_containing_undf/2)
    |> flatten_path()
  end

  defp merge_if_containing_undf(output, acc) do
    acc =
      Enum.reduce(output, acc, fn
        {_, :any}, acc ->
          acc

        {k, v}, acc ->
          case Map.get(acc, k) do
            :undefined ->
              Map.put(acc, k, v)

            _ ->
              acc
          end
      end)

    all_hit =
      acc |> Map.values() |> Enum.all?(&(&1 != :undefined))

    if all_hit, do: {:halt, acc}, else: {:cont, acc}
  end

  defp reverse_merge(context, %Table{} = table) do
    table =
      Map.update!(table, :rules, fn rules ->
        Stream.map(rules, fn [number | rest] ->
          [-number | rest]
        end)
      end)

    merge(context, table)
  end

  def match_rule?(condition, context) do
    Enum.all?(condition, fn {key, expect} ->
      match_expect?(expect, get_in(context, key))
    end)
  end

  def match_expect?(expect, value) when is_list(expect) do
    Enum.any?(expect, &match_expect?(&1, value))
  end

  def match_expect?(%Range{first: first, last: last}, value) when is_number(value) do
    # we can't use `in` here because value may be a float.
    value >= first and value <= last
  end

  def match_expect?({:>, x}, value) when is_number(value) and value > x, do: true
  def match_expect?({:>=, x}, value) when is_number(value) and value >= x, do: true
  def match_expect?({:<, x}, value) when is_number(value) and value < x, do: true
  def match_expect?({:<=, x}, value) when is_number(value) and value <= x, do: true

  def match_expect?(:any, _), do: true
  def match_expect?(expect, expect), do: true
  def match_expect?(_, _), do: false

  defp flatten_path(outputs) do
    Enum.reduce(outputs, %{}, fn {path, v}, acc ->
      acc |> put_recursively(path, v)
    end)
  end

  defp put_recursively(%{} = acc, [path], value) do
    Map.put(acc, path, value)
  end

  defp put_recursively(%{} = acc, [head | rest], value) do
    v = put_recursively(%{}, rest, value)
    Map.update(acc, head, v, &Map.merge(&1, v))
  end
end
