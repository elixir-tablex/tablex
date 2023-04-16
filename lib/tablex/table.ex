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
          valid?: boolean() | :undefined
        }

  @type hit_policy() :: :first_hit | :merge | :reverse_merge | :collect
  @type input() :: Variable.t()
  @type output() :: Variable.t()
  @type var_name() :: atom()
  @type var_type() :: :string | :number | :integer | :float | :date | :time | :datetime
  @type rule() :: [order :: integer() | {:input, [any()]} | {:output, [any()]}]

  defstruct hit_policy: :first_hit, inputs: [], outputs: [], rules: [], valid?: :undefined

  @doc false
  def new(parsed) do
    %__MODULE__{
      hit_policy: parsed[:hit_policy],
      inputs: Keyword.get_values(parsed, :input),
      outputs: Keyword.get_values(parsed, :output),
      rules: parsed[:rules]
    }
    |> apply_info_row(parsed[:info])
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
end
