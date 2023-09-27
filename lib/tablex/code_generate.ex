defmodule Tablex.CodeGenerate do
  @moduledoc """
  This module is responsible for generating Elixir code from a table.
  """

  alias Tablex.Parser
  alias Tablex.Table
  alias Tablex.Util.DeepMap

  @flatten_path """
    put_recursively = fn
      _, [], value, _ ->
        value

      %{} = acc, [head | rest], value, f ->
        v = f.(%{}, rest, value, f)

        Map.update(acc, head, v, fn
          old_v ->
            Map.merge(old_v, v, fn
              _, %{} = v1, %{} = v2 ->
                Map.merge(v1, v2)

              _, _, v2 ->
                v2
            end)
        end)
    end

    flatten_path = fn outputs ->
      Enum.reduce(outputs, %{}, fn {path, v}, acc ->
        acc |> put_recursively.(path, v, put_recursively)
      end)
    end
  """

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
    [
      "binding =\n",
      ["  case {", top_input_tuple_expr(table), "} do\n"],
      rule_clauses(table) |> Enum.intersperse("\n"),
      "\nend"
    ]
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
    code |> IO.iodata_to_binary()
  end

  def generate(%Table{hit_policy: :collect, inputs: in_def} = table) do
    rule_functions =
      table.rules
      |> Enum.map_intersperse(",\n", fn [_, {:input, inputs}, {:output, outputs}] ->
        [
          "if(match?(",
          rule_cond(inputs, in_def),
          ", {",
          top_input_tuple_expr(table),
          "}), do: ",
          to_output(outputs, table.outputs),
          ?)
        ]
      end)

    ["for ret when not is_nil(ret) <- [", rule_functions, "], do: ret"]
    |> IO.iodata_to_binary()
  end

  def generate(%Table{hit_policy: :merge} = table) do
    empty = table.outputs |> Enum.map(fn _ -> :any end)

    clauses =
      table.rules
      |> Enum.map_intersperse(", ", fn
        [_, {:input, rule_inputs}, {:output, rule_outputs} | _] ->
          [
            "fn\n",
            [
              "  ",
              rule_cond(rule_inputs, table.inputs),
              " -> ",
              rule_output_values(rule_outputs),
              "\n"
            ],
            "  _ -> nil\n",
            "end"
          ]
      end)

    [
      "binding = {",
      top_input_tuple_expr(table),
      ?},
      ?\n,
      "out_values = [",
      clauses,
      "]\n",
      "|> Enum.reduce_while(",
      inspect(empty),
      """
      , fn rule_fn, acc ->
        case rule_fn.(binding) do
          output when is_list(output) ->
            {acc, []} =
              output
              |> Enum.reduce({[], acc}, fn
                :any, {acc, [h | t]} ->
                  {[h | acc], t}

                other, {acc, [:any | t]} ->
                  {[other | acc], t}

                _other, {acc, [other | t]} ->
                  {[other | acc], t}
              end)

            acc = Enum.reverse(acc)

            if Enum.member?(acc, :any),
              do: {:cont, acc},
              else: {:halt, acc}

          nil ->
            {:cont, acc}
        end
      end)
      """,
      @flatten_path,
      "\n",
      "Stream.zip([",
      output_pathes(table.outputs) |> Enum.intersperse(", "),
      "], out_values)\n",
      "|> flatten_path.()"
    ]
    |> IO.iodata_to_binary()
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

  defp top_input_tuple_expr(%{inputs: inputs}) do
    Enum.map_intersperse(inputs, ", ", fn %{name: var, path: path} ->
      (path ++ [var]) |> hd() |> to_string()
    end)
  end

  defp rule_clauses(%{rules: rules, inputs: in_def, outputs: out_def}) do
    rules
    |> Stream.map(&rule_clause(&1, in_def, out_def))
  end

  defp rule_clause([_n, input: inputs, output: outputs], in_def, out_def) do
    [rule_cond(inputs, in_def), " ->\n  ", to_output(outputs, out_def)]
  end

  defp rule_cond(inputs, in_def) do
    {patterns, guards} =
      inputs
      |> Stream.zip(in_def)
      |> Enum.reduce({[], []}, fn {value, df}, {p, g} ->
        case pattern_guard(value, df) do
          {pattern, guard} ->
            {[to_nested_pattern(pattern, df) | p], [guard | g]}

          pattern ->
            {[to_nested_pattern(pattern, df) | p], g}
        end
      end)

    case {patterns, guards} do
      {_, []} ->
        ["{", patterns |> Enum.reverse() |> Enum.intersperse(", "), "}"]

      _ ->
        p = ["{", patterns |> Enum.reverse() |> Enum.intersperse(", "), "}"]
        w = guards |> Enum.intersperse(" and ")

        [p, " when ", w]
    end
  end

  defp pattern_guard(:any, _), do: "_"

  defp pattern_guard({comp, number}, %{name: name, path: path}) when comp in ~w[!= < <= >= >]a do
    var_name = Enum.join(path ++ [name], "_")

    {var_name,
     ["is_number(", var_name, ") and ", var_name, " ", to_string(comp), " ", to_string(number)]}
  end

  defp pattern_guard(%Range{first: first, last: last}, %{name: name, path: path}) do
    var_name = Enum.join(path ++ [name], "_")

    {var_name, [var_name, " in ", "#{first}..#{last}"]}
  end

  defp pattern_guard(list, %{name: name, path: path} = var) when is_list(list) do
    var_name = Enum.join(path ++ [name], "_")

    case Enum.split_with(list, &is_literal/1) do
      {[], complex_values} ->
        join_pattern_guard(var_name, complex_values, var)

      {literal_values, []} ->
        {var_name, join_literal_pattern_guard(var_name, literal_values)}

      {literal_values, complex_values} ->
        {^var_name, complex_pattern} = join_pattern_guard(var_name, complex_values, var)

        {
          var_name,
          [join_literal_pattern_guard(var_name, literal_values), " or ", complex_pattern]
        }
    end
  end

  defp pattern_guard(literal, _) when is_literal(literal) do
    inspect(literal)
  end

  defp join_literal_pattern_guard(var_name, [v]) do
    [var_name, " == ", inspect(v)]
  end

  defp join_literal_pattern_guard(var_name, list) do
    [var_name, " in ", inspect(list, charlists: :as_lists)]
  end

  defp join_pattern_guard(var_name, list, %{name: name, path: path}) when is_list(list) do
    guard =
      list
      |> Stream.map(&pattern_guard(&1, %{name: name, path: path}))
      |> Enum.map_intersperse(" or ", fn
        {_var, guard} ->
          guard

        value when is_binary(value) ->
          [var_name, " == ", value]
      end)

    {var_name, ["(", guard, ")"]}
  end

  defp to_output(outputs, out_def) do
    map =
      Stream.zip(out_def, outputs)
      |> Map.new(fn
        {%{name: name, path: path}, value} ->
          {path ++ [name], value}
      end)

    map |> DeepMap.flatten() |> to_code()
  end

  defp to_code(%{} = map) do
    kvs =
      map
      |> Enum.map_join(", ", fn {k, v} ->
        [to_string(k), ": ", to_code(v)]
      end)

    ["%{", kvs, "}"]
  end

  defp to_code({:code, code}) when is_binary(code) do
    code
  end

  defp to_code(v) do
    inspect(v)
  end

  defp rule_output_values(outputs) do
    [
      "[",
      outputs
      |> Stream.map(&to_code/1)
      |> Enum.intersperse(", "),
      "]"
    ]
  end

  defp output_pathes(outputs) do
    for %{name: name, path: path} <- outputs, do: inspect(path ++ [name])
  end

  defp to_nested_pattern("_", _) do
    "_"
  end

  defp to_nested_pattern(flat_pattern, %{name: name, path: path}) do
    %{tl(path ++ [name]) => {:code, flat_pattern}}
    |> DeepMap.flatten()
    |> to_code()
  end
end
