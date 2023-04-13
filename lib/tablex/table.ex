defmodule Tablex.Table do
  @moduledoc """
  Struct definition for tables.
  """
  @type t() :: %__MODULE__{
          hit_policy: hit_policy(),
          inputs: [input()],
          outputs: [output()],
          rules: [rule()],
          valid?: boolean() | :undefined
        }

  @type hit_policy() :: :first_hit | :merge | :reverse_merge | :collect
  @type input() :: {var_name(), var_type()}
  @type output() :: {var_name(), var_type()}
  @type var_name() :: atom()
  @type var_type() :: :string | :number | :integer | :float | :date | :time | :datetime
  @type rule() :: [order :: integer() | {:input, [any()]} | {:output, [any()]}]

  defstruct hit_policy: :first_hit, inputs: [], outputs: [], rules: [], valid?: :undefined

  def new(parsed) do
    %__MODULE__{
      hit_policy: parsed[:hit_policy],
      inputs: Keyword.get_values(parsed, :input),
      outputs: Keyword.get_values(parsed, :output),
      rules: parsed[:rules]
    }
  end
end
