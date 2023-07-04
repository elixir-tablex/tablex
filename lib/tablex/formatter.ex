defmodule Tablex.Formatter do
  @moduledoc """
  This module is responsible for turning a table into text.
  """
  alias Tablex.Table
  alias Tablex.Variable

  def to_s(table, dir \\ :horizontal)

  def to_s(%Table{} = table, :horizontal) do
    (render_header(table) ++ render_rules(table))
    |> align_columns()
    |> Enum.join("\n")
  end

  defp render_header(table) do
    has_info_row? = has_info_row?(table)

    first_row =
      [render_hit_policy(table)]
      |> Enum.concat(render_input_defs(table, has_info_row?))
      |> Enum.concat(["||"])
      |> Enum.concat(render_output_defs(table, has_info_row?))

    [
      first_row | render_info_row(table)
    ]
  end

  defp has_info_row?(table) do
    Enum.any?(table.inputs, &has_desc?/1) or Enum.any?(table.outputs, &has_desc?/1)
  end

  defp has_desc?(%{desc: desc}) when is_binary(desc), do: true
  defp has_desc?(_), do: false

  defp render_hit_policy(%{hit_policy: :first_hit}),
    do: "F"

  defp render_hit_policy(%{hit_policy: :merge}),
    do: "M"

  defp render_hit_policy(%{hit_policy: :collect}),
    do: "C"

  defp render_hit_policy(%{hit_policy: :reverse_merge}),
    do: "RM"

  defp render_input_defs(%{inputs: inputs}, has_info_row?) do
    inputs
    |> Enum.map(&render_var_def(&1, has_info_row?))
  end

  defp render_var_def(%Variable{} = var, true) do
    maybe_quoted(var.label)
  end

  defp render_var_def(%Variable{} = var, false) do
    case var.type do
      :undefined ->
        maybe_quoted(var.label)

      type ->
        [maybe_quoted(var.label), " (", render_var_type(type), ")"]
        |> IO.iodata_to_binary()
    end
  end

  defp maybe_quoted(str) do
    if String.contains?(str, " ") do
      inspect(str)
    else
      str
    end
  end

  defp render_var_type(:undefined) do
    []
  end

  defp render_var_type(type) do
    [type_to_string(type)]
  end

  defp type_to_string(type), do: to_string(type)

  defp render_output_defs(%{outputs: outputs}, has_info_row?) do
    outputs
    |> Stream.map(&render_var_def(&1, has_info_row?))
    |> Enum.intersperse(" ")
  end

  defp render_info_row(table) do
    if has_info_row?(table) do
      [
        [" "] ++
          (table.inputs |> Enum.map(&render_var_desc/1)) ++
          ["||"] ++
          (table.outputs |> Enum.map(&render_var_desc/1))
      ]
    else
      []
    end
  end

  defp render_var_desc(%Variable{desc: nil}), do: "-"
  defp render_var_desc(%Variable{type: :undefined}), do: "-"

  defp render_var_desc(%Variable{type: type, desc: desc}),
    do: ["(", type_to_string(type), ", ", desc, ")"] |> IO.iodata_to_binary()

  defp render_rules(table) do
    table.rules
    |> Enum.map(&render_rule/1)
  end

  defp render_rule([id, {:input, input_values}, {:output, output_values}]) do
    [
      to_string(id),
      Enum.map(input_values, &render_value/1),
      "||",
      Enum.map(output_values, &render_value/1)
    ]
    |> List.flatten()
  end

  defp render_value([_ | _] = value) do
    Enum.map_join(value, ",", &render_value/1)
  end

  defp render_value(:any), do: "-"
  defp render_value(true), do: "yes"
  defp render_value(false), do: "no"
  defp render_value(n) when is_number(n), do: to_string(n)
  defp render_value(nil), do: "null"
  defp render_value(%Range{first: first, last: last}), do: "#{first}..#{last}"

  defp render_value(str) when is_binary(str) do
    maybe_quoted(str)
  end

  defp render_value(value) do
    inspect(value)
  end

  defp align_columns(lines) do
    lines
    |> Stream.zip()
    |> Stream.map(fn columns ->
      columns = Tuple.to_list(columns)

      max_len =
        columns
        |> Stream.map(&String.length/1)
        |> Enum.max()

      columns
      |> Enum.map(&String.pad_trailing(&1, max_len))
    end)
    |> Stream.zip()
    |> Enum.map(fn line ->
      line
      |> Tuple.to_list()
      |> Enum.join(" ")
    end)
  end
end
