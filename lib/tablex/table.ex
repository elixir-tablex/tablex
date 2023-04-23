defmodule Tablex.Table do
  @moduledoc """
  Struct definition for tables.
  """

  alias Tablex.Variable

  @type t() :: %__MODULE__{
          hit_policy: hit_policy(),
          inputs: [input()],
          outputs: [output()],
          rules: [rule()],
          valid?: boolean() | :undefined,
          table_dir: :h | :v
        }

  @type hit_policy() :: :first_hit | :merge | :reverse_merge | :collect
  @type input() :: Variable.t()
  @type output() :: Variable.t()
  @type var_name() :: atom()
  @type var_type() :: :string | :number | :integer | :float | :date | :time | :datetime
  @type rule() :: [order :: integer() | {:input, [any()]} | {:output, [any()]}]

  defstruct hit_policy: :first_hit,
            inputs: [],
            outputs: [],
            rules: [],
            valid?: :undefined,
            table_dir: :h

  @doc false
  def new([{:horizontal, parsed}]) do
    %__MODULE__{
      hit_policy: parsed[:hit_policy],
      inputs: Keyword.get_values(parsed, :input),
      outputs: Keyword.get_values(parsed, :output),
      rules: parsed[:rules]
    }
    |> apply_info_row(parsed[:info])
  end

  def new([{:vertical, parsed}]) do
    inputs =
      parsed
      |> Enum.flat_map(fn
        {:input, [%Variable{} = v | _]} -> [v]
        _ -> []
      end)

    outputs =
      parsed
      |> Enum.flat_map(fn
        {:output, [%Variable{} = v | _]} -> [v]
        _ -> []
      end)

    %__MODULE__{
      hit_policy: parsed[:hit_policy],
      inputs: inputs,
      outputs: outputs,
      rules: build_vertical_rules(parsed),
      table_dir: :v
    }
  end

  defp apply_info_row(table, nil) do
    table
  end

  defp apply_info_row(table, [input_info, output_info]) do
    apply_info = fn
      {var, {type, desc}} ->
        %{var | type: type, desc: desc}
    end

    inputs =
      Stream.zip(table.inputs, input_info)
      |> Enum.map(apply_info)

    outputs =
      Stream.zip(table.outputs, output_info)
      |> Enum.map(apply_info)

    %{table | inputs: inputs, outputs: outputs}
  end

  defp build_vertical_rules(parsed) do
    has_input? =
      Enum.any?(
        parsed,
        fn
          {:input, _} -> true
          _ -> false
        end
      )

    if has_input?,
      do: build_vertical_rules(parsed, :has_input),
      else: build_vertical_rules(parsed, :no_input)
  end

  defp build_vertical_rules(parsed, :has_input) do
    condition_matrix =
      parsed
      |> Stream.flat_map(fn
        {:input, [%Variable{} | conditions]} ->
          [conditions]

        _ ->
          []
      end)
      |> Stream.zip()

    value_matrix =
      parsed
      |> Stream.flat_map(fn
        {:output, [%Variable{} | values]} ->
          [values]

        _ ->
          []
      end)
      |> Stream.zip()

    rule_numbers = parsed[:rule_numbers]

    Stream.zip([rule_numbers, condition_matrix, value_matrix])
    |> Enum.map(fn {nu, inputs, outputs} ->
      [nu, {:input, Tuple.to_list(inputs)}, {:output, Tuple.to_list(outputs)}]
    end)
  end

  defp build_vertical_rules(parsed, :no_input) do
    value_matrix =
      parsed
      |> Stream.flat_map(fn
        {:output, [%Variable{} | values]} ->
          [values]

        _ ->
          []
      end)
      |> Stream.zip()

    rule_numbers = parsed[:rule_numbers]

    Stream.zip([rule_numbers, value_matrix])
    |> Enum.map(fn {nu, outputs} ->
      [nu, {:input, []}, {:output, Tuple.to_list(outputs)}]
    end)
  end
end
