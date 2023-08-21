defmodule Tablex.Formatter.Horizontal do
  alias Tablex.Table

  import Tablex.Formatter.HitPolicy, only: [render_hit_policy: 1]
  import Tablex.Formatter.Variable, only: [render_var_def: 2, render_var_desc: 1]
  import Tablex.Formatter.Align, only: [align_columns: 1]

  def to_s(%Table{} = table) do
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

  defp render_input_defs(%{inputs: inputs}, has_info_row?) do
    inputs
    |> Enum.map(&render_var_def(&1, has_info_row?))
  end

  defp render_output_defs(%{outputs: outputs}, has_info_row?) do
    outputs
    |> Enum.map(&render_var_def(&1, has_info_row?))
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

  defp render_rules(table) do
    table.rules
    |> Stream.with_index(1)
    |> Enum.map(&render_rule/1)
  end

  defp render_rule({[_original_id, {:input, input_values}, {:output, output_values}], id}) do
    [
      to_string(id),
      Enum.map(input_values, &render_value/1),
      "||",
      Enum.map(output_values, &render_value/1)
    ]
    |> List.flatten()
  end

  defp render_value(value) do
    Tablex.Formatter.Value.render_value(value)
    |> IO.iodata_to_binary()
  end
end
