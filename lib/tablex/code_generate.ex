defmodule Tablex.CodeGenerate do
  @moduledoc """
  This module is responsible for generating Elixir code from a table.
  """

  alias Tablex.Parser
  alias Tablex.Table

  defguardp(
    is_literal(exp)
    when is_nil(exp) or is_atom(exp) or is_number(exp) or is_binary(exp) or is_map(exp)
  )

  @doc """
  Transform a table into Elixir code.


  ## Examples

      iex> table = \"""
      ...> F CreditScore EmploymentStatus Debt-to-Income-Ratio || Action
      ...> 1 700         employed         <0.43                || Approved
      ...> 2 700         unemployed       -                    || "Further Review"
      ...> 3 <=700       -                -                    || Denied
      ...> \"""
      ...>
      ...> code = generate(table)
      ...> is_binary(code)
      true
      


  The code generated in the above example is:

      case {credit_score, employment_status, debt_to_income_ratio} do
        {700, "employed", debt_to_income_ratio}
        when is_number(debt_to_income_ratio) and debt_to_income_ratio < 0.43 ->
          %{action: "Approved"}

        {700, "unemployed", _} ->
          %{action: "Further Review"}

        {credit_score, _, _} when is_number(credit_score) and credit_score <= 700 ->
          %{action: "Denied"}
      end

  """
  @spec generate(String.t() | Table.t()) :: String.t()
  def generate(table) when is_binary(table) do
    table |> Parser.parse!([]) |> generate()
  end

  def generate(%Table{hit_policy: :first_hit} = table) do
    """
    case {#{input_vars(table) |> Enum.join(", ")}} do
      #{rule_clauses(table) |> Enum.join("\n")}
    end
    """
    |> Code.format_string!()
    |> IO.iodata_to_binary()
  end

  def generate(%Table{hit_policy: :collect, rules: rules, inputs: [], outputs: out_def}) do
    outputs =
      rules
      |> Stream.map(fn [_, _input, {:output, outputs}] ->
        to_output(outputs, out_def)
      end)
      |> Enum.intersperse(", ")

    code = [?[ | outputs] ++ [?]]
    code |> IO.iodata_to_binary() |> Code.format_string!() |> IO.iodata_to_binary()
  end

  def generate(%Table{hit_policy: :collect, inputs: in_def} = table) do
    rule_functions =
      table.rules
      |> expand_rules()
      |> Enum.map(fn [_, {:input, input}, {:output, outputs}] ->
        """
        if(match?(#{rule_cond(input, in_def)}, {#{input_vars(table) |> Enum.join(",")}}),
          do: [#{to_output(outputs, table.outputs)}],
          else: [])
        """
        |> String.trim_trailing()
      end)

    """
    List.flatten([
      #{rule_functions |> Enum.join(",\n")}
    ])
    """
  end

  def generate(%Table{hit_policy: :merge} = table) do
    empty = for %{name: var} <- table.outputs, into: %{}, do: {var, :undefined}
    inputs = for %{name: var} <- table.inputs, do: var

    """
    binding = {#{inputs |> Enum.join(", ")}}

    [#{table.rules |> expand_rules() |> Stream.map(fn [_, {:input, input}, {:output, outputs}] -> """
      fn
        #{rule_cond(input, table.inputs)} ->
          #{to_output(outputs, table.outputs)}

        _ ->
          nil
      end
      """ |> String.trim_trailing() end) |> Enum.join(",\n")}]
    |> Enum.reduce_while(#{inspect(empty)}, fn rule_fn, acc ->
      case rule_fn.(binding) do
        %{} = output ->
          acc =
            Enum.reduce(acc, acc, fn
              {k, :undefined}, acc ->
                case Map.get(output, k) do
                  :any ->
                    acc

                  v ->
                    Map.put(acc, k, v)
                end

              _, acc ->
                acc
            end)

          if Map.values(acc) |> Enum.member?(:undefined) do
            {:cont, acc}
          else
            {:halt, acc}
          end

        nil ->
          {:cont, acc}
      end
    end)
    """
  end

  def generate(%Table{hit_policy: :reverse_merge} = table) do
    table =
      Map.update!(table, :rules, fn rules ->
        Enum.reverse(rules)
        |> Stream.with_index(1)
        |> Enum.map(fn {[_ | rest], n} -> [n | rest] end)
      end)

    generate(%{table | hit_policy: :merge})
  end

  defp input_vars(%{inputs: inputs}) do
    Enum.map(inputs, fn
      %{name: var, path: []} ->
        var

      %{path: [root | _]} ->
        root
    end)
  end

  defp rule_clauses(%{rules: rules, inputs: in_def, outputs: out_def}) do
    rules
    |> expand_rules()
    |> Stream.map(&rule_clause(&1, in_def, out_def))
  end

  defp expand_rules(rules) do
    rules |> Stream.flat_map(&expand_rule/1)
  end

  defp expand_rule([_n, {:input, []} | _] = rule) do
    [rule]
  end

  defp expand_rule([n, {:input, [input | rest]} | output]) when is_list(input) do
    for elem <- input, r <- expand_rule([n, {:input, [elem | rest]} | output]) do
      r
    end
  end

  defp expand_rule([n, {:input, [input | rest]} | output]) do
    for [^n, {:input, inputs} | ^output] <- expand_rule([n, {:input, rest} | output]) do
      [n, {:input, [input | inputs]} | output]
    end
  end

  defp rule_clause([_n, input: inputs, output: outputs], in_def, out_def) do
    """
    #{rule_cond(inputs, in_def)} ->
      #{to_output(outputs, out_def)}
    """
  end

  defp rule_cond(inputs, in_def) do
    {patterns, guards} =
      inputs
      |> Stream.zip(in_def)
      |> Enum.reduce({[], []}, fn {value, df}, {p, g} ->
        case pattern_guard(value, df) do
          {pattern, guard} ->
            {[to_string(pattern) | p], [guard | g]}

          pattern ->
            {[to_string(pattern) | p], g}
        end
      end)

    case {patterns, guards} do
      {_, []} ->
        "{#{patterns |> Enum.reverse() |> Enum.join(", ")}}"

      _ ->
        p = "{#{patterns |> Enum.reverse() |> Enum.join(", ")}}"
        w = guards |> Enum.join(" and ")
        p <> " when " <> w
    end
  end

  defp pattern_guard(:any, _), do: "_"

  defp pattern_guard({comp, number}, %{name: name, path: path}) when comp in ~w[!= < <= >= >]a do
    var_name = Enum.join(path ++ [name], "_")

    {on_path(var_name, tl(path ++ [name])),
     "is_number(#{var_name}) and #{var_name} #{comp} #{number}"}
  end

  defp pattern_guard(%Range{first: first, last: last}, %{name: name, path: path}) do
    var_name = Enum.join(path ++ [name], "_")

    {on_path(var_name, tl(path ++ [name])), "#{var_name} in #{first}..#{last}"}
  end

  defp pattern_guard(list, %{name: name, path: path}) when is_list(list) do
    var_name = Enum.join(path ++ [name], "_")

    {on_path(var_name, tl(path ++ [name])), "#{var_name} in #{inspect(list)}"}
  end

  defp pattern_guard(literal, %{name: name, path: path}) when is_literal(literal) do
    on_path(inspect(literal), tl(path ++ [name]))
  end

  defp on_path(name, []), do: name

  defp on_path(name, [head | tail]) do
    "%{#{head}: #{on_path(name, tail)}}"
  end

  defp to_output(outputs, out_def) do
    parts =
      Stream.zip(out_def, outputs)
      |> Stream.map(fn
        {%{name: name}, {:code, code}} ->
          "#{name}: #{code}"

        {%{name: name}, value} ->
          "#{name}: #{inspect(value)}"
      end)
      |> Enum.join(", ")

    ["%{", parts, "}"]
  end
end
