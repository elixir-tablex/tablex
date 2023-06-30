defmodule Tablex.Formatter.Vertical do
  alias Tablex.Table

  import Tablex.Formatter.HitPolicy, only: [render_hit_policy: 1]
  import Tablex.Formatter.Value, only: [render_value: 1]
  import Tablex.Formatter.Variable, only: [render_var_def: 2, render_var_desc: 1]
  import Tablex.Formatter.Align, only: [align_columns: 1]

  def to_s(%Table{} = table) do
    lines =
      [render_first_line(table) | render_inputs(table)] ++ render_outputs(table)

    lines
    |> align_columns()
    |> add_hr_at(input_size(table) + 1)
    |> add_hr_at(0)
    |> Enum.intersperse("\n")
    |> IO.iodata_to_binary()
  end

  defp render_first_line(table) do
    [
      render_hit_policy(table),
      "||" | render_rule_numbers(table)
    ]
  end

  defp render_rule_numbers(table) do
    table.rules
    |> Stream.with_index(1)
    |> Enum.map(fn {_, id} -> to_string(id) end)
  end

  defp render_inputs(table) do
    table.rules
    |> Stream.map(fn [_id, {:input, inputs} | _] -> inputs end)
    |> Stream.zip()
    |> Stream.zip(table.inputs)
    |> Stream.map(fn {values, input_def} ->
      [render_var(input_def, false), "||" | render_values(values)]
    end)
    |> Enum.to_list()
  end

  defp render_var(%{desc: nil} = var_def, _) do
    render_var_def(var_def, false)
  end

  defp render_var(var_def, _) do
    render_var_def(var_def, true) <> " " <> render_var_desc(var_def)
  end

  defp render_values(values) do
    values |> Tuple.to_list() |> Enum.map(&render_value/1)
  end

  defp render_outputs(table) do
    table.rules
    |> Stream.map(fn [_id, _, {:output, outputs} | _] -> outputs end)
    |> Stream.zip()
    |> Stream.zip(table.outputs)
    |> Stream.map(fn {values, output_def} ->
      [render_var(output_def, false), "||" | render_values(values)]
    end)
    |> Enum.to_list()
  end

  defp input_size(%{inputs: inputs}) do
    length(inputs)
  end

  defp add_hr_at(lines, pos) do
    List.insert_at(lines, pos, hr())
  end

  defp hr, do: "===="
end
